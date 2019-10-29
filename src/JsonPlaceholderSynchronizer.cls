/*
 * This a simple class to sync contacts, posts and comments from JSONPlaceholder (https://jsonplaceholder.typicode.com/)
 * into our salesforce application.
 * The sync logic simply fetches all users, posts & comments and updates them to the database.
 * Drawbacks:
 *  1. If there are large number of users/posts/comments, we might run into salesforce governor limits
 *  2. We fetch all users/posts/comments everytime, which is inefficient.
 * Ideally, the architecture should be event driven, or there sould be api's on the server to get changed objects, changed object counts etc.
 * However, given the existing architecture and JSONPlaceholder api's, I have implemented the below logic.
 * */

public class JsonPlaceholderSynchronizer {

    public void sync(){
        try {
            //first fetch all objects from JSONPlaceholder (do all callouts)
            List<JsonPlaceholderService.User> userObjs = JsonPlaceholderService.getUsers();
            List<JsonPlaceholderService.Post> postObjs = JsonPlaceholderService.getPosts();
            List<JsonPlaceholderService.Comment> commentObjs = JsonPlaceholderService.getComments();
            
            //now sync in order, first contacts, then posts, then comments
            syncContacts(userObjs);
            syncPosts(postObjs);
            syncComments(commentObjs);
        } catch(Exception e) {
            /* throw the exception as this is only called from a scheduled job (not UI),
             * and we want to rollback any database changes.
             * Not using savepoints, keeping it simple
             */
            throw e; 
        }
    }

    private void syncContacts(List<JsonPlaceholderService.User> objs){
        Map<String, Contact> existingContactsMap = getExistingContactsMap();
        List<Contact> contacts = new List<Contact>();
        convertToSObjects(existingContactsMap,objs,contacts);
        upsert contacts;
    }
 
    private void syncPosts(List<JsonPlaceholderService.Post> objs){
        Map<String, Post__c> existingPostsMap = getExistingPostsMap();
        List<Post__c> posts = new List<Post__c>();
        convertToSObjects(existingPostsMap,objs,posts);
        
        //link contact lookup field
        Map<String, Contact> existingContactsMap = getExistingContactsMap();
        for(Post__c p : posts){
            p.Contact__c = existingContactsMap.get(p.UserId__c).Id;
        }
        upsert posts;
    }

    private void syncComments(List<JsonPlaceholderService.Comment> objs){
        Map<String, Comment__c> existingCommentsMap = getExistingCommentsMap();
        List<Comment__c> comments = new List<Comment__c>();
        convertToSObjects(existingCommentsMap,objs,comments);
        
        //link post__c lookup field
        Map<String, Post__c> existingPostsMap = getExistingPostsMap();
        for(Comment__c c : comments){
            c.Post__c = existingPostsMap.get(c.PostId__c).Id;
        }
        upsert comments;
    }

    private void convertToSObjects(Map<String, SObject> existingMap,
        List<JsonPlaceholderService.JsonPlaceholderObject> objs, List<SObject> sObjs){
    	
        for(JsonPlaceholderService.JsonPlaceholderObject obj: objs){
            if(existingMap.containsKey(obj.getId())){ 
                SObject existing = existingMap.get(obj.getId());
                // for now isChanged always returns true, as comparing fields would not be efficient,
                // and we could run into cpu limits if there are large number of objects being checked
                if(obj.isChanged(existing)){
                    SObject updatedSObject = obj.toSObject();
                    updatedSObject.Id = existing.Id;
                    sObjs.add(updatedSObject);
                }
            } else {
                sObjs.add(obj.toSObject());
            }
        }
    }
    
    private Map<String,Contact> getExistingContactsMap(){
        Map<String, Contact> m = new Map<String, Contact>();
        for(Contact c: [select ContactId__c from Contact where ContactId__c != null]){
            m.put(c.ContactId__c, c);
        }
        return m;
    }
    private Map<String,Post__c> getExistingPostsMap(){
        Map<String, Post__c> m = new Map<String, Post__c>();
        for(Post__c p: [select PostId__c from Post__c where PostId__c != null]){
            m.put(p.PostId__c, p);
        }
        return m;
    }
    private Map<String,Comment__c> getExistingCommentsMap(){
        Map<String, Comment__c> m = new Map<String, Comment__c>();
        for(Comment__c c: [select CommentId__c from Comment__c where CommentId__c != null]){
            m.put(c.CommentId__c, c);
        }
        return m;
    }
}