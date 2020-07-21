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
                {
                    "inputType": "text"
                    "key": "firstName|lastName|middleInitial"
                },
                {
                    "inputType": "number"
                    "key": "zipCode"
                },
                {
                    "inputType": "dobMY|dobDMY"
                    "key": "month|year|day"
                },
                ,
                {
                    "inputType": "selection"
                    "key": "county"
                    "options": [
                        "Kings (Brooklyn)"
                    ]
                }
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
        "county": "Kings",
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


:white_check_mark: **POST** **`/voterRoll/save`**
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

:white_check_mark: **POST** **`/user/notificationToken`**
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


:white_check_mark: **GET** **`/user/location`**
**Authorization:** `Token from Firebase Auth`

```js
// Request

// Response
{
    "location": {
        "state": "NJ",
        "zipcode" "12345",
        "legislativeDistrict": "6",
        "congressionalDistrict": "40"
    }
}
```

:white_check_mark: **POST** **`/user/location`**
**Authorization:** `Token from Firebase Auth`

Saves the state and district of the user on the backend into a table
```js
// Request
{
    "locationUpdate": {
        "location": {
            "lat": 0,
            "lng": 0
        }
    }
}

// Response
{
    "location": {
        "state": "NJ",
        "latlng": {
            "lat": 0,
            "lng": 0
        }
        "zipcode" "12345",
        "legislativeDistrict": "6",
        "congressionalDistrict": "40"
    }
}
```

### Firebase Firestore Tables


:white_check_mark: **notification_auth_tokens**

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

:white_check_mark: **electoral_register**  

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

:white_check_mark: **locations**  

Contains a list of all the users that have chosen to save their data.

```js
[
    {
        "user-auth-token": {
            "state": "NJ",
            "zipcode" "12345",
            "legislativeDistrict": "6",
            "congressionalDistrict": "40"
        }
    }
]
```