# Tokens

The tokens endpoint serves the purpose to provide the client user a safe way to either request a safe, expirable token to interact with the rest of the API or to change credentials such as a password reset.

Notice that tokens have an expiration date, depending on the type of token. Authentication tokens will last for 1 hour whereas password reset tokens will last for 1 day. If you get an unauthorized error you should request a new token.

## Create

> Roles: **admin**, **customer**

Creates a new token for the given type. You should use this endpoint to request an _"authentication"_ token so you can interact with the rest of the application.


### Request

`POST /tokens`

#### Headers

_None._

### Parameters

 - **token[type]** *Required.* The type of the token to request. Can be either `authentication` or `password_reset`.
 - **token[user][email]** *Required.* Email of the user to create the token for.
 - **token[user][password]** *Optional.* Password for the user requesting the token. Only necessary when requesting a `authentication` type of token.

### Payload

```json
{
    "token": {
        "token_type": "authentication",
        "user": {
            "email": "john07@example.com",
            "password": "Testing@123!"
        }
    }
}
```

### Response

`201 created`

```json
{
    "token": "8taehCMah79rgdWkkvTMgjbz",
    "token_type": "authentication",
    "expires_at": "2017-09-30T00:33:42.648Z",
    "url": "https://walletapi.xyz/tokens/2bc2844a-0b3a-4c53-beaa-2bf5e2eaf37b.json"
}
```

#### Headers

_None._

# Users

The users endpoints allow interaction with user type resources and can be used to manage them. Although there are enpoints for all RESTful operations only a handful are available for regular users and are restricted for their own resource data. All other operations require admin permissions.

## Create

> Roles: **admin**

Creates a new user with the given data. This endpoint is restricted to admin operations. By default, when creating a new user a new wallet account will be created as well with a balance of 0.

### Request

`POST /users`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user[email]** *Required*. The email of the new user account to create.
 - **user[password]** *Optional*. A temporary password for the newly created user. If none is set, a random password will be generated.
 - **user[first_name]** *Required.* The new user's first name.
 - **user[last_name]** *Required.* The new user's last name.
 - **user[role]** *Optional.* Role for the new user. This can be either `customer` or `admin`. If none is given it will fallback to a customer.
 - **user[status]** *Optional.* The status of the user once created. Can be any of `active` to immediately have the user activated _(useful when providing password)_ `unconfirmed` if the user requires confirmation by email or `disabled` to create the user but have the account disabled to interact with the API. Fallsback to `unconfirmed` if none given.

### Payload

```json
{
	"user": {
		"email": "john@example.com",
		"password": "S3cur3Pwd!",
		"first_name": "John",
		"last_name": "Doe",
		"role": "customer",
		"status": "active"
	}
}
```

### Response

`201 created`

```json
{
    "id": "cbe467a9-9059-4a4c-ab84-93d9b453b901",
    "email": "john01@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "customer",
    "status": "unconfirmed",
    "created_at": "2017-09-28T03:46:27.470Z",
    "updated_at": "2017-09-28T03:46:27.470Z",
    "account": {
        "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e",
        "balance": "0.0",
        "account_type": "customer",
        "created_at": "2017-09-29T03:56:39.408Z",
        "updated_at": "2017-09-29T03:56:39.408Z"
    },
    "url": "https://walletapi.xyz/users/cbe467a9-9059-4a4c-ab84-93d9b453b901.json"
}
```

#### Headers

_None._

## Index

> Roles: **admin**

Lists current users in the system. Both `customer` and `admin` types. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **page** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
    {
        "id": "cbe467a9-9059-4a4c-ab84-93d9b453b901",
        "email": "john01@example.com",
        "first_name": "John",
        "last_name": "Doe",
        "role": "customer",
        "status": "unconfirmed",
        "created_at": "2017-09-28T03:46:27.470Z",
        "updated_at": "2017-09-28T03:46:27.470Z",
        "account": {
            "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e",
            "balance": "0.0",
            "account_type": "customer",
            "created_at": "2017-09-29T03:56:39.408Z",
            "updated_at": "2017-09-29T03:56:39.408Z"
        },
        "url": "https://walletapi.xyz/users/cbe467a9-9059-4a4c-ab84-93d9b453b901.json"
    },
    {
        "id": "1b491220-028f-40e2-84be-cd9f9d5d93e6",
        "email": "john02@example.com",
        "first_name": "John",
        "last_name": "Doe",
        "role": "customer",
        "status": "unconfirmed",
        "created_at": "2017-09-28T03:46:39.938Z",
        "updated_at": "2017-09-28T03:46:39.938Z",
        "account": {
            "id": "3785f7f3-d2e1-4691-a288-6742aa7fbfe0",
            "balance": "0.0",
            "account_type": "customer",
            "created_at": "2017-09-29T03:52:19.565Z",
            "updated_at": "2017-09-29T03:52:19.565Z"
        },
        "url": "https://walletapi.xyz/users/1b491220-028f-40e2-84be-cd9f9d5d93e6.json"
    }
]
```

#### Headers

 - **X-Total-Pages**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain user. If the given user id is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other users.

### Request

`GET /users/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **id** *Required*. The unique ID of the user to retrieve.

### Payload

_None._

### Response

`200 ok`

```json
{
    "id": "cbe467a9-9059-4a4c-ab84-93d9b453b901",
    "email": "john01@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "customer",
    "status": "unconfirmed",
    "created_at": "2017-09-28T03:46:27.470Z",
    "updated_at": "2017-09-28T03:46:27.470Z",
    "account": {
        "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e",
        "balance": "0.0",
        "account_type": "customer",
        "created_at": "2017-09-29T03:56:39.408Z",
        "updated_at": "2017-09-29T03:56:39.408Z"
    },
    "url": "https://walletapi.xyz/users/cbe467a9-9059-4a4c-ab84-93d9b453b901.json"
}
```

#### Headers

_None._

## Update

> Roles: **admin**, **customer**

Updates an existing user with the given data. This endpoint does not support updating a user's password or email and is only purpose is to update personal data for the user. If the requesting user is an admin it can change any other user's data, otherwise it can only change the requesting user's data. Trying to change other's user's data with a `customer` role will cause a `401 unauthorized` http error.

### Request

`PATCH /users/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user[first_name]** *Optional.* The updated user first name.
 - **user[last_name]** *Optional.* The updated user last name.
 - **user[role]** *Optional.* Role for the updated user. This can be either `customer` or `admin`.
 - **user[status]** *Optional.* The status of the user. Can be any of `active`, `unconfirmed` if the user requires confirmation by email or `disabled` to disable the user.

### Payload

```json
{
	"first_name": "John",
	"last_name": "Doe",
	"role": "customer",
	"status": "disabled",
}
```

### Response

`200 ok`

```json
{
    "id": "cbe467a9-9059-4a4c-ab84-93d9b453b901",
    "email": "john01@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "customer",
    "status": "disabled",
    "created_at": "2017-09-28T03:46:27.470Z",
    "updated_at": "2017-09-28T03:46:27.470Z",
    "account": {
        "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e",
        "balance": "0.0",
        "account_type": "customer",
        "created_at": "2017-09-29T03:56:39.408Z",
        "updated_at": "2017-09-29T03:56:39.408Z"
    },
    "url": "https://walletapi.xyz/users/cbe467a9-9059-4a4c-ab84-93d9b453b901.json"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**

Removes an existing user from the system. This endpoint is only accesible by `admin` users. Do note that if a user has existing transactions an error will be returned and instead the user must be disabled or _soft deleted_ to keep integrity of data.

### Request

`DELETE /users/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **id** *Required.* The unique ID of the user to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._

# Transactions

Transactions are the basis of the wallet system. A transaction represents an operation between entities that affects balances of both sides, even for operations not involving electronic money. For instance, a _wallet_ to _wallet_ transfer of electronic money is the most common, however, there are other operations that a user can do such as recharging the wallet or withdrawing the money.

These transactions are always made on behalf of the calling client wallet, that is, all created transactions happen because one of the ends is the client's wallet.

For these transactions there exist different types of operations:

 1. A wallet to wallet transfer. For instance, customer John Doe transfering e-money to Jane Smith.
 2. A wallet deposit, that is, when the customer wishes to add credit to the wallet from a debit or a credit card.
 3. A wallet withdrawal, when the customer wants to move money away from the wallet outside the system to a debit or a credit card.

There are another two types of operations which cannot be created by the user but can appear on balances and they happen internally and automatically:

 1. A flat fee that is applied when a wallet to wallet operation occurs, where the payee is charged such amount. The fee depends on the amount being transfered and these fees can be consulted in the `fees` endpoint.
 2. A variable rate fee which is applied when a wallet to wallet operation occurs, where the payee is charged such amount which is calculated as the `(amount x rate)`. The fee depends on the amount being transfered and these fees can be consulted in the `fees` endpoint.

Client can provide an amount and a description for the transfer so it reminds of the reason of the operation.

Once an operation suceeds the current balance will be stored for historial reasons and to generate a useful statement. There is a field called `reference` which is used internally and will store a reference to a parent transaction in the case that the transaction was the consequence of another which is the case of the fees.

Since transactions are related to real money they cannot be deleted once they have been succesful. For such purpose a dispute process should be done where the target entity that received the money creates another operation to balance the account again in the principles of banking and financial systems. The only attribute that could be modified once a transaction is done is the `description` which is mostly for the end-user purposes and does not affect the balances.

## Create

> Roles: **admin**, **customer**

Creates a new transaction for the given type and the given amount. This transaction is executed on behalf of the user passed as parameter so if the calling client is not the user of the resource the endpoint will return a `401 unauthorized` http error unless the calling client is an `admin`

In order to create transactions the client must provide the type of transaction that needs to be executed which is limited to the ones that are available to wallets being:

 - `transfer` transfer money from the calling client to another customer wallet.
 - `deposit` charge the wallet from an existing credit or debit card from the customer.
 - `withdrawal` move money from the wallet to a customer's debit or credit card.

The other two types are not available for use, that is `flat_fee` and `variable_fee` since they are created or triggered by other transactions automatically. These are not even available for admin users.

Depending on the type of transaction the client must provide the ID of a _"transferable"_ object which can be either a wallet from another user for transfers between users or a card from the calling client in case of a deposit or withdrawal. Naturally, a client can only transfer money from his/her wallet to another and not the other way around and can also only withdraw from or deposit to his/her own cards.

For operations that involve interaction with 3rd parties such as other banks if a problem occurs on the third party a `502 bad gateway` error will be returned. This is a possible scenario if there is a downtime or connection problem to the credit or debit card issuer. Also note that insuficient funds or problems with the account itself do not account as gateway problems.

Finally, an important thing to consider is that the calling client must have enough funds on the wallet for the operation to succeeed in the case of wallet-to-wallet transfer because of the fees considering that the operation is actually the desired transfer amount + fees. If there are not enough funds then the request will fail.

### Request

`POST /users/:user_id/transactions`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **transaction[amount]** *Required*. The amount to be transfered to the other account.
 - **transaction[transaction_type]** *Required*. The type of transaction desired. Can be either `transfer`, `deposit` or `withdrawal`.
 - **transaction[description]** *Optional*. A user description of the reason of the operation. For statement purposes.
 - **transaction[transferable][id]** *Required.* The unique ID of the transferable object which can be a `card` or `wallet` depending on the `transaction_type`.

### Payload

```json
{
    "transaction": {
        "amount": 2000,
        "transaction_type": "transfer",
        "description": "A test transfer",
        "transferable": {
            "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e"
        }
    }
}
```

### Response

`201 created`

```json
{
    "id": "94801348-a654-4d5d-b575-8be507fc6fd1",
    "amount": "2000.0",
    "type": "transfer",
    "description": "A test transfer",
    "reference": null,
    "balance": "0.0",
    "created_at": "2017-09-30T03:45:59.996Z",
    "transferable": {
        "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e"
    },
    "url": "https://walletapi.xyz/users/cbe467a9-9059-4a4c-ab84-93d9b453b901/transactions/94801348-a654-4d5d-b575-8be507fc6fd1.json"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists the transactions for the given user. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users/:user_id/transations`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user_id** *Required*. The unique ID of the user whose transactions are to be retrieved.
 - **page** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
    {
        "id": "78c7b0d1-7148-41d6-9d44-7edc7ae81390",
        "amount": "1000.0",
        "type": "transfer",
        "description": "A test transfer",
        "reference": null,
        "balance": "2000.0",
        "created_at": "2017-09-30T03:48:26.228Z",
        "transferable": {
            "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e"
        },
        "url": "http://localhost:3000/users/cbe467a9-9059-4a4c-ab84-93d9b453b901/transactions/78c7b0d1-7148-41d6-9d44-7edc7ae81390.json"
    },
    {
        "id": "7e4b313b-1e9f-4702-8600-02472ab1a1e6",
        "amount": "8.0",
        "type": "flat_fee",
        "description": "Flat fee",
        "reference": "78c7b0d1",
        "balance": "1992.0",
        "created_at": "2017-09-30T03:54:37.094Z",
        "url": "http://localhost:3000/users/cbe467a9-9059-4a4c-ab84-93d9b453b901/transactions/7e4b313b-1e9f-4702-8600-02472ab1a1e6.json"
    },
    {
        "id": "fcb9287d-c335-45cc-aa9a-128e2bac3d6d",
        "amount": "30.0",
        "type": "variable_fee",
        "description": "Variable fee",
        "reference": "78c7b0d1",
        "balance": "1962.0",
        "created_at": "2017-09-30T03:55:31.092Z",
        "url": "http://localhost:3000/users/cbe467a9-9059-4a4c-ab84-93d9b453b901/transactions/fcb9287d-c335-45cc-aa9a-128e2bac3d6d.json"
    }
]
```

#### Headers

 - **X-Total-Pages**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain transaction. If the given user uuid is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other user transactions.

### Request

`GET /users/:user_id/transations/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user_id** *Required*. The unique ID of the user whose transaction is to be retrieved.
 - **id** *Required*. The unique ID of the user transaction.

### Payload

_None._

### Response

`200 ok`

```json
{
    "id": "78c7b0d1-7148-41d6-9d44-7edc7ae81390",
    "amount": "1000.0",
    "type": "transfer",
    "description": "A test transfer",
    "reference": null,
    "balance": "2000.0",
    "created_at": "2017-09-30T03:48:26.228Z",
    "transferable": {
        "id": "2ae667b5-6ae5-4565-8f87-24d776c6684e"
    },
    "url": "http://localhost:3000/users/cbe467a9-9059-4a4c-ab84-93d9b453b901/transactions/78c7b0d1-7148-41d6-9d44-7edc7ae81390.json"
}
```

#### Headers

_None._

# Cards

Cards are used in the system for two purposes mainly: to transfer money to or from the wallet. A card can be either a credit or debit card regardless of the bank.

While a wallet does not need a card, it is the only way to charge the wallet unless another user transfers money to the other user wallet. Also, to withdraw the money the user would need a card that the money can be transfered to.

Although initially the whole set of data from the card is requested we do not store it for security reasons. The only data that will be stored are the last 4 digits to keep a reference for statement purposes and also the expiration date to notify the user whenever the card is about to expire or in the case that a transaction is to be made with a card that has expired to avoid costs involved with failed charges common on financial systems.

Also, a card cannot be modified. If a user wishes to edit data from a card then the card needs to be removed and added back.

Lastly, if the card has been already involved in transactions a _soft delete_ is going to happen in order to keep integrity of the data. Since no personal information is stored from the cards there is no concern of data at store even if the customer decided to remove the card. The field `status` will set this and it can be either `active` or `removed`.

## Create

> Roles: **admin**, **customer**

Creates a new card with the given data. Card will be tested against issuer for validity when added but not for funds as no charge will be done. A card can be either a credit or debit card.

### Request

`POST /users/:user_id/cards`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **card[name_on_card]** *Required*. The name as it appears in the card.
 - **card[number]** *Required*. Card number digits.
 - **card[csc]** *Required*. Card security code.
 - **card[expiration_year]** *Required*. Card expiration year.
 - **card[expiration_month]** *Required*. Card expiration month.
 - **card[card_type]** *Required.* Can be either `debit` or `credit`.
 - **card[issuer]** *Required.* The issuer of the card which can be one of the following: `visa`, `mastercard`, `amex`, `dinners` or `discover`.

### Payload

```json
{
    "card": {
        "name_on_card": "John Doe",
        "number": "4111111111111111",
        "csc": "123",
        "expiration_year": "2020",
        "expiration_month": "06",
        "card_type": "credit",
        "issuer": "visa"
    }
}
```

### Response

`201 created`

```json
{
    "id": "473c3d1f-b4bd-4dfe-84b8-e09a5188efd4",
    "last_4": "1111",
    "card_type": "credit",
    "issuer": "visa",
    "status": "active",
    "expiration_year": "2020",
    "expiration_month": "06",
    "url": "https://walletapi.xyz/users/1b491220-028f-40e2-84be-cd9f9d5d93e6/cards/473c3d1f-b4bd-4dfe-84b8-e09a5188efd4.json"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists all the active cards for the given user. If the requesting client is a `customer` it will default to active cards, `admin` users can list also inactive cards for historical purposes. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /users/:user_id/cards`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user_id** *Required*. The unique ID of the user whose cards are to be retrieved.
 - **page** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
    {
        "id": "ba527302-9684-4f51-8858-a52214df4e95",
        "last_4": "1111",
        "card_type": "credit",
        "issuer": "visa",
        "status": "active",
        "expiration_year": "2018",
        "expiration_month": "09",
        "url": "https://walletapi.xyz/users/1b491220-028f-40e2-84be-cd9f9d5d93e6/cards/ba527302-9684-4f51-8858-a52214df4e95.json"
    },
    {
        "id": "63b7243a-9769-4c15-afad-d7ee4506783d",
        "last_4": "1111",
        "card_type": "credit",
        "issuer": "visa",
        "status": "active",
        "expiration_year": "2020",
        "expiration_month": "06",
        "url": "https://walletapi.xyz/users/1b491220-028f-40e2-84be-cd9f9d5d93e6/cards/63b7243a-9769-4c15-afad-d7ee4506783d.json"
    }
]
```

#### Headers

 - **X-Total-Pages**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**, **customer**

Returns the details of a certain transaction. If the given user uuid is not the client's request user and the client's request user is a customer a `401 unauthorized` http error will be returned. Only admin users can retrieve details for all other user transactions.

### Request

`GET /users/:user_id/cards/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user_id** *Required*. The unique ID of the user whose card is to be retrieved.
 - **id** *Required*. The unique ID of the user card.

### Payload

_None._

### Response

`200 ok`

```json
{
    "id": "ba527302-9684-4f51-8858-a52214df4e95",
    "last_4": "1111",
    "card_type": "credit",
    "issuer": "visa",
    "status": "active",
    "expiration_year": "2018",
    "expiration_month": "09",
    "url": "https://walletapi.xyz/users/1b491220-028f-40e2-84be-cd9f9d5d93e6/cards/ba527302-9684-4f51-8858-a52214df4e95.json"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**, **customer**

Removes an existing card from a user on the system. If there are any transactions on the card already then the card is _soft deleted_ and its status is set to `removed` instead meaning that it won't appear anymore for the user but `admin` users can still see them.

### Request

`DELETE /users/:user_id/cards/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **user_id** *Required.* The unique ID of the user to whose card is to be removed.
 - **id** *Required.* The unique ID of the user's card to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._


# Fees

Fees are objects that set how much is charged per each transaction, particularily those between wallets. Each transaction will have both a flat fee charge and a variable rate fee calculated from the transfer amount. These fees are then withdrawn from the customer's wallet.

These fees are basically upper and lower bounds for amounts tied to the fee amount and the variable rate or ranges. These endpoints are all for administrative purposes so no regular `customer` type of account can access them.

Fee records do not have relation between transactions and instead the historic balance field and description are used to store at a certain point of time this information as rates may change with time.

## Create

> Roles: **admin**

Creates a new fee.

### Request

`POST /fees`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **fee[description]** *Required*. A unique name/description for this fee.
 - **fee[lower_range]** *Required*. The lower range for this fee.
 - **fee[upper_range]** *Required*. The upper range for this fee.
 - **fee[flat_fee]** *Required*. The flat fee for this range.
 - **fee[variable_fee]** *Required*. The variable rate fee.

### Payload

```json
{
	"fee": {
		"description": "A unique name/description for this fee",
		"lower_range": 0,
		"upper_range": 1000.00,
		"flat_fee": 8.00,
		"variable_fee": 3.0
	}
}
```

### Response

`201 created`

```json
{
    "id": "8447fee2-7931-490c-a90e-e18b814bbe0e",
    "description": "A unique name/description for this fee",
    "lower_range": "0.0",
    "upper_range": "1000.0",
    "flat_fee": "8.0",
    "variable_fee": "3.0",
    "created_at": "2017-09-28T22:29:42.234Z",
    "updated_at": "2017-09-28T22:29:42.234Z",
    "url": "https://walletapi.xyz/fees/8447fee2-7931-490c-a90e-e18b814bbe0e.json"
}
```

#### Headers

_None._

## Index

> Roles: **admin**, **customer**

Lists all the fee ranges in the system. By default only the last 10 created records are returned. Parameters must be sent in order to retrieve the next pages. See below

### Request

`GET /fees`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **page** *Optional*. If set, will pull records for the given page. The response `X-Total-Pages` value can be used to discover how many pages are.

### Payload

_None._

### Response

`200 ok`

```json
[
    {
        "id": "16f7373e-23ab-4b25-bc75-f73610a49be3",
        "description": "2nd",
        "lower_range": "1001.0",
        "upper_range": "5000.0",
        "flat_fee": "6.0",
        "variable_fee": "2.5",
        "created_at": "2017-09-28T04:20:52.648Z",
        "updated_at": "2017-09-28T04:20:52.648Z",
        "url": "https://walletapi.xyz/fees/16f7373e-23ab-4b25-bc75-f73610a49be3.json"
    },
    {
        "id": "976f80f4-5987-4177-a53a-dd9a55e2d4ae",
        "description": "3rd",
        "lower_range": "5001.0",
        "upper_range": "10000.0",
        "flat_fee": "4.0",
        "variable_fee": "2.0",
        "created_at": "2017-09-28T04:21:30.380Z",
        "updated_at": "2017-09-28T04:21:30.380Z",
        "url": "https://walletapi.xyz/fees/976f80f4-5987-4177-a53a-dd9a55e2d4ae.json"
    }
]
```

#### Headers

 - **X-Total-Pages**. An integer containing the total amount of pages that the client can paginate through.

## Show

> Roles: **admin**

Returns the details for a fee.

### Request

`GET /fees/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **id** *Required*. The unique ID of the fee.

### Payload

_None._

### Response

`200 ok`

```json
{
    "id": "8447fee2-7931-490c-a90e-e18b814bbe0e",
    "description": "Another description",
    "lower_range": "0.0",
    "upper_range": "1000.0",
    "flat_fee": "8.0",
    "variable_fee": "3.0",
    "created_at": "2017-09-28T22:29:42.234Z",
    "updated_at": "2017-09-28T22:35:54.865Z",
    "url": "https://walletapi.xyz/fees/8447fee2-7931-490c-a90e-e18b814bbe0e.json"
}
```

#### Headers

_None._

## Delete

> Roles: **admin**

Removes a fee from the system.

### Request

`DELETE /fees/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters

 - **id** *Required.* The unique ID of the fee to delete.

### Payload

_None._

### Response

`203 no content`

_None_.

#### Headers

_None._

## Update

> Roles: **admin**

Updates an existing fee.

### Request

`PATCH /fees/:id`

#### Headers

 - **Accept** *Optional*. Mime-Type that the client expects. Could be `application/json`, `application/xml` or `application/csv` for instance.
 - **Content-Type** *Optional*. The type of content being sent to the server. If the payload does not contain any binaries such as files or images the recommended is `application/json` otherwise it is recommended to use `multipart/form-data`.
 - **X-User-Email** *Required*. The email of the user account making the request.
 - **X-User-Token** *Required*. The secret token of the user to make the request. You can get one by using the `/tokens` endpoint.

### Parameters


 - **fee[description]** *Optional*. A unique name/description for this fee.
 - **fee[lower_range]** *Optional*. The lower range for this fee.
 - **fee[upper_range]** *Optional*. The upper range for this fee.
 - **fee[flat_fee]** *Optional*. The flat fee for this range.
 - **fee[variable_rate]** *Optional*. The variable rate fee.

### Payload

```json
{
	"fee": {
		"description": "Another description",
		"lower_range": 0,
		"upper_range": 1000.00,
		"flat_fee": 8.00,
		"variable_rate": 4.5
	}
}
```

### Response

`200 ok`

```json
{
    "id": "8447fee2-7931-490c-a90e-e18b814bbe0e",
    "description": "Another description",
    "lower_range": "0.0",
    "upper_range": "1000.0",
    "flat_fee": "8.0",
    "variable_fee": "3.0",
    "created_at": "2017-09-28T22:29:42.234Z",
    "updated_at": "2017-09-28T22:35:54.865Z",
    "url": "https://walletapi.xyz/fees/8447fee2-7931-490c-a90e-e18b814bbe0e.json"
}
```

#### Headers

_None._
