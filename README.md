# Politic


- [ ] Privacy policy about data usage



## APIs

**GET** **`/api/v1/electoralRegister/states`**

Static data stored in Firestore and cached for 1 day. Data will be modified when more voter registration are added to functions.

```json
{
    "states": [
        {
            "name": "New Jersey",
            "abbreviation": "NJ",
            "fields": [
                "firstName",
                "lastName",
                "dobMY",
                "zipCode"
            ],
            "disabledReason": {
                "reason": "markdown", // nullable
                "phone": "213-123-123",
                "website": "https://..."
            }
        }
    ]
}
```


**POST** **`/api/v1/electoralRegister/check`**


```json
// Request

{
    "voterInformation": {
        "state": "NJ", // Using the abbreviation for the state and the key/id, non-null
        "firstName": "First", // nullable
        "lastName": "Second", // nullable
        "middleInitial": "I", // nullable
        "month": "MM", // 01 or 12, nullable
        "year": 2012 // nullable
    }
}

// Response
{
    "voterStatus": {
        "result" : {
            "type": "multipleEnrolled|singleEnrolled|notEnrolled|none",
            "value": { // singleEnrolled
                "voterData": [
                    {
                        "title": "",
                        "message": ""
                    }
                ]
            },
            "value": [{ // multipleEnrolled
                "voterData": [
                    {
                        "title": "",
                        "message": ""
                    }
                ]
            }],
            "value": [{ // none
                "voterData": [
                    {
                        "title": "",
                        "message": ""
                    }
                ]
            }],
            "value": { // notEnrolled 
                "requirements": "markdown",
                "registrationUrl": "https://" // URL for user to register at. 
            }
        }
    }
}
```



**POST** **`/api/v1/electoralRegister/save`**
**Authorization:** `Token from Firebase Auth`

Saving voter registration data, 

```json
// Request
{
    "enrollment": {
        "voterInformation": {
            "state": "NJ", // Using the abbreviation for the state and the key/id
            "firstName": "First",
            "lastName": "Second",
            "middleInitial": "I",
            "month": "MM", // 01 or 12
            "year": 2012
        },
        "notificationToken": "token" // Token from Firebase Notifications
    }
   
}

// No response
```

**POST** **`/api/v1/electoralRegister/manual`**
**Authorization:** `Token from Firebase Auth`


```json
// Request
{
    "manualEnrollment": {
        "enrolled": false,
        "notificationToken": "token" // Token from Firebase Notifications
    }
   
}

// No response
```

**POST** **`/api/v1/updateToken`**
**Authorization:** `Token from Firebase Auth`


```json
// Request
{
    "tokenUpdate": {
        "token": "token"
    }
}

// No response
```
### Firebase Firestore Tables


**notification_auth_tokens**

```json
[
    {
        "user-auth-token": {
            "token": "token" // token send from device
        }
    }
]
```

**electoral_register**  

Contains a list of all the users that have chosen to save their data.

```json
[
    {
        "user-auth-token": {
            "voterInformation": {
                "state": "NJ", // Using the abbreviation for the state and the key/id
                "firstName": "First",
                "lastName": "Second",
                "middleInitial": "I",
                "month": "MM", // 01 or 12
                "year": 2012
            },
            "manualMarkedEnrolled": "zonedDateTime",
            "lastCheck": "zonedDateTime", // The last time a cron job was run on the users voter status or the last time the user manually checked.
            "lastStatus": "enrolled|unenrolled|unknown" 
        }
    }
]
```