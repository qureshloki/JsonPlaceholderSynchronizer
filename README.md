#### Description:

This is the Salesforce.com Apex code for simple JSON object syncronization. It is suppose to pull contacts, posts and comments from the JSONPlaceholder website and save the records in the system on a daily basis.

This was coded as part of an interview assignment.

#### Given Requirements:

1. The data model/schema provided on the Saleforce org and the field mapping between the JSONPlaceholder objects and the salesforce objects is given as:

   ![Schema](schemaAndFieldMap.JPG?raw=true)

#### Implementation:

- I have implemented a Schedulabe class which could be scheduled to run daily.
- It pulls all users,posts & comments from Jsonplaceholder and updates it to the database.
- I have assumed here that Jsonplaceholder is the single source of truth and all objects received from there are updated to the database irresepective of changes that may have been done on a record on the salesforce side.
- I have mentioned few comments in the classes that highlight any limitations/assumptions made.
