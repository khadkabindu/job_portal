# job_portal

job_portal is a web app that lists the various technology job posts and allows users to filter the job posts using the job tags available.

## Run Application

#### Step 1:
Go to the project root and get the required dependencies.
```
flutter pub get
```
#### Step 2: 
To launch the project on chrome.
```
flutter run -d chrome
``` 
## Implementation
### Assumptions
#### Filter Tags
The job posts are being filtered based on the key "keywords" from API which is the list of the strings. Using those keywords the application displays the list of all the unique keywords at the top of the applications UI. Tapping on the keywords filters the data accordingly.

#### Filter Condition
In order to filter the jobs posts all the selected keywords should match the keywords present in the job post, if no match of keywords is found then the view displays the message - no jobs found with the selected keywords.



## Improvements
In this current version of app, I am rendering all the listed keywords in a scrollable list view but for large keywords this process will not be user friendly because the user have to scroll to the end of the list view to find the keyword that they are searching for, instead of this we can implement it using a Dropdown menu with the search feature that contains the job tags like 
<a href= "https://remoteok.com/"> Remote Ok</a>.


------------------------------------------
Thank you for taking time to review my assignment. I would love to have your suggestions and feedbacks on this.
