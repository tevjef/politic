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
            ]
        }
    ]
}
```


**POST** **`/api/v1/electoralRegister/check`**


```json
// Request

{
    "voterInformation": {
        // Using the abbreviation for the state and the key/id, non-null
        "state": "NJ", 
        // nullable
        "firstName": "First", 
        // nullable
        "lastName": "Second", 
        // nullable
        "middleInitial": "I", 
        // 01 or 12, nullable
        "month": "MM", 
        // nullable
        "year": 2012 
    }
}

// Response
{
    "voterStatus": {
        "result" : {
            "type": "multipleEnrolled|singleEnrolled|notEnrolled|none",
            // singleEnrolled
            "value": { 
                "voterData": [
                    {
                        "title": "",
                        "message": ""
                    }
                ]
            },
            // multipleEnrolled
            "value": [{ 
                "voterData": [
                    {
                        "title": "",
                        "message": ""
                    }
                ]
            }],
            // none
            "value": {
                "phone": "212-555-5555",
                "web": "https://..."
            },
            // notEnrolled 
            "value": { 
                "requirements": "markdown",
                // URL for user to register at. 
                "registrationUrl": "https://" 
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
            
            "state": "NJ", 
            "firstName": "First",
            "lastName": "Second",
            "middleInitial": "I",
            // 01 or 12
            "month": "MM", 
            "year": 2012
        },
        // Token from Firebase Notifications
        "notificationToken": "token" 
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
        // Token from Firebase Notifications
        "notificationToken": "token" 
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
            // token send from device
            "token": "token" 
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
                // Using the abbreviation for the state and the key/id
                "state": "NJ", 
                "firstName": "First",
                "lastName": "Second",
                "middleInitial": "I",
                // 01 or 12
                "month": "MM",
                "year": 2012
            },
            "manualMarkedEnrolled": "zonedDateTime",
            // The last time a cron job was run on the users voter status or the last time the user manually checked.
            "lastCheck": "zonedDateTime", 
            "lastStatus": "enrolled|unenrolled|unknown" 
        }
    }
]
```