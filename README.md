# Politic


- [ ] Privacy policy about data usage
- [ ] Geocoding


## APIs

:white_check_mark: **GET** **`/voterRoll/states`**

Static data stored in Firestore and cached for 1 day. Data will be modified when more voter registration are added to functions.

```js
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


:white_check_mark: **POST** **`/voterRoll/checkRegistration`**


```js
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
        "type": "multipleEnrolled|singleEnrolled|notEnrolled|notFound",
        // singleEnrolled
        "value":  [
            {
                "title": "",
                "message": ""
            }
        ],
        // multipleEnrolled
        "value": [{ 
            "voterData": [
                {
                    "title": "",
                    "message": ""
                }
            ]
        }],
        // notFound
        "value": { 
            "phone": { 
                "label": "212-555-5555",
                "uri": "",
            "requirements": "markdown",
            // URL for user to register at. 
            "registrationUrl": { "label": "https://", "uri": "" }
        },
        // notEnrolled 
        "value": { 
            "phone": { 
                "label": "212-555-5555",
                "uri": "",
            "requirements": "markdown",
            // URL for user to register at. 
            "registrationUrl": { "label": "https://", "uri": "" }
        }
    }
}
```

:white_check_mark: **GET** **`/feed/states/{state}`**

```js
// Request
// - Path parameter with the state abbreviation

// Response 
{
  "feed": [
    {
      "itemType": "keyVote",
      "title": "Amends Teacher Health Benefits (S 2273) - Passage Passed - Executive",
      "link": "http://votesmart.org/bill/28233/73218"
    }
  ],
  "representatives": [
    {
      "displayName": "Robert Menendez",
      "image": "https://theunitedstates.io/images/congress/225x275/M000639.jpg",
      "bioguide": "M000639"
    }
  ]
}
```


:x: **POST** **`/voterRoll/save`**
**Authorization:** `Token from Firebase Auth`

Saving voter registration data, 

```js
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

:x: **POST** **`/voterRoll/manual`**
**Authorization:** `Token from Firebase Auth`


```js
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

:x: **POST** **`/updateToken`**
**Authorization:** `Token from Firebase Auth`


```js
// Request
{
    "tokenUpdate": {
        "token": "token"
    }
}

// No response
```
### Firebase Firestore Tables


:x: **notification_auth_tokens**

```js
[
    {
        "user-auth-token": {
            // token send from device
            "token": "token" 
        }
    }
]
```

:x: **voter_roll_states**

```js
[
    {
        "state-name": {
                        "phone": { 
                "label": "212-555-5555",
                "uri": "",
                        },
            "requirements": "markdown",
            // URL for user to register at. 
            "registrationUrl": { "label": "https://", "uri": "" }
        }
    }
]
```

:x: **electoral_register**  

Contains a list of all the users that have chosen to save their data.

```js
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