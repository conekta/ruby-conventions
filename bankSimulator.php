<?php

$responseCodes = [
    "SUCCESSFUL_TRANSACTION" => [
        "code" => "1000",
        "status" => "SUCCESSFUL_TRANSACTION",
        "reference" => sha1("1000")
    ],
    "INVALID_CARD_NUMBER" => [
        "code" => "1001",
        "status"=> "INVALID_CARD_NUMBER",
        "reference" => sha1("1001")
    ],
    "INVALID_CARD_ADDRESS" => [
        "code" => "1002",
        "status" => "INVALID_CARD_ADDRESS",
        "reference" => sha1("1002")
    ],
    "INVALID_CARD_CSC" => [
        "code" => "1003",
        "status" => "INVALID_CARD_CSC",
        "reference" => sha1("1003")
    ],
    "EXPIRED_CARD" => [
        "code" => "1004",
        "status" => "EXPIRED_CARD",
        "reference" => sha1("1004")
    ],
    "CARD_DECLINED" => [
        "code" => "5000",
        "status" => "CARD_DECLINED",
        "reference" => sha1("5000")
    ],
    "INSUFFICIENT_FUNDS" => [
        "code" => "6000",
        "status" => "INSUFFICIENT_FUNDS",
        "reference" => sha1("6000")
    ],
    "INVALID_CARD_TOKEN" => [
        "code" => "7000",
        "status" => "INVALID_CARD_TOKEN",
        "reference" => sha1("7000")
    ],
    "INVALID_TRANSACTION_TYPE" => [
        "code" => "8000",
        "status" => "INVALID_TRANSACTION_TYPE",
        "reference" => sha1("8000")
    ],
    "INVALID_XML_INPUT" => [
        "code" => "9000",
        "status" => "INVALID_XML_INPUT",
        "reference" => sha1("9000")
    ]
];
define("RESPONSE_CODES", $responseCodes);

$xmlResponse = <<<XML
<?xml version='1.0' standalone='yes'?>
<transaction>
    <code></code>
    <status></status>
    <reference></reference>
</transaction>
XML;
define("XML_RESPONSE", $xmlResponse);


function authenticateUser() {
    $username = null;
    $password = null;
    $validUser = false;

    if (isset($_SERVER["PHP_AUTH_USER"])) {
        if (!empty($_SERVER["PHP_AUTH_USER"])) {
            $username = $_SERVER["PHP_AUTH_USER"];
        }
    }

    if (isset($_SERVER["PHP_AUTH_PW"])) {
        if (!empty($_SERVER["PHP_AUTH_PW"])) {
            $password = $_SERVER["PHP_AUTH_PW"];
        }
    }

    if (empty($username) || empty($password)) {
        header('WWW-Authenticate: Basic realm="Restricted Area"');
        header('HTTP/1.0 401 Unauthorized');
        echo "You need to authenticate";
        exit;
    } else {
        if($username != "walletapi" || $password != "Testing@123!") {
            header('WWW-Authenticate: Basic realm="Restricted Area"');
            header("HTTP/1.0 403 Forbidden");
            echo "Wrong credentials";
            exit;
        }
    }
}

function returnResponse($responseType, $reference = null) {
    $code = RESPONSE_CODES[$responseType];
    $response = new SimpleXMLElement(XML_RESPONSE);
    $response->code =  $code["code"];
    $response->status =  $code["status"];
    if (isset($reference)) {
        $response->reference = $reference;
    } else {
        $response->reference =  $code["reference"];
    }

    echo $response->asXML();
    exit;
}

function validateInput() {
    // check transaction type
    $transactionType = $_GET["transaction"];
    if (empty($transactionType) || in_array($transactionType, ["card", "deposit", "withdrawal"]) == false) {
        returnResponse("INVALID_TRANSACTION_TYPE");
    }

    // check valid xml
    libxml_use_internal_errors(true);
    $xml = file_get_contents('php://input');
    $transaction = simplexml_load_string($xml);

    if($transaction == false) {
        returnResponse("INVALID_XML_INPUT");
    } else {
        createOperation($transaction, $transactionType);
    }
}

function createOperation($transaction, $transactionType) {
    switch ($transactionType) {
        case "card":
            addCard($transaction);
            break;
        case "withdrawal":
            withdraw($transaction);
            break;
        case "deposit":
            deposit($transaction);
        default:
            # code...
            break;
    }
}

function addCard($transaction) {
    switch (substr(preg_replace("/-/", "", $transaction->number), -4)) {
        case "1000":
            returnResponse("SUCCESSFUL_TRANSACTION");
            break;
        case "1001":
            returnResponse("INVALID_CARD_NUMBER");
            break;
        case "1002":
            returnResponse("INVALID_CARD_ADDRESS");
            break;
        case "1003":
            returnResponse("INVALID_CARD_CSC");
            break;
        case "1004":
            returnResponse("EXPIRED_CARD");
            break;
        case "6000":
            returnResponse("SUCCESSFUL_TRANSACTION", RESPONSE_CODES["INSUFFICIENT_FUNDS"]["reference"]);
            break;
        default:
            returnResponse("INVALID_CARD_NUMBER");
            break;
    }
}

function withdraw($transaction) {
    switch ($transaction->cardToken) {
        case sha1("1000"):
            returnResponse("SUCCESSFUL_TRANSACTION");
            break;
        case sha1("5000"):
            returnResponse("CARD_DECLINED");
            break;
        case sha1("6000"):
            returnResponse("INSUFFICIENT_FUNDS");
            break;
        default:
            returnResponse("INVALID_CARD_TOKEN");
            break;
    }
}

function deposit($transaction) {
    switch ($transaction->cardToken) {
        case sha1("1000"):
            returnResponse("SUCCESSFUL_TRANSACTION");
            break;
        case sha1("6000"):
            returnResponse("SUCCESSFUL_TRANSACTION");
            break;
        default:
            returnResponse("INVALID_CARD_TOKEN");
            break;
    }
}

authenticateUser();
validateInput();
