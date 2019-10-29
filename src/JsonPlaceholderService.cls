public class JsonPlaceholderService {
	private static final String JSON_PLACEHOLDER_BASE_URL = 'https://jsonplaceholder.typicode.com'; //should use custom setting but keeping it simple
    
    public static String getBaseUrl(){
        return JSON_PLACEHOLDER_BASE_URL;
    }

    public abstract class JsonPlaceholderObject {    
        public abstract String getId();
        public abstract SObject toSObject();

        public virtual boolean isChanged(SObject existing){
            // for now we are not comparing fields as this is not efficient and we could run into governor limits,
            // if there are large number of objects being checked.
            return true;
        }        
    }
    
    public class User extends JsonPlaceholderObject {
        private String id {get;set;}
        public override String getId(){
            return id;
        }
        private String name {get; set {
            name = value != null ? value.normalizeSpace() : value;
        }} 
        private String username {get; set;}
        private String email {get; set;} 
        private String phone {get; set;}
        private String website {get; set;}
        
        public override SObject toSObject(){
            Contact c = new Contact(ContactId__c=id, Username__c=username,
            	Email = email, Phone = phone, Website__c=website);
            setContactName(c);
            return c;
        }
        private void setContactName(Contact c){
            if(String.isEmpty(name)) return;
            String[] fullname = new String[3];
            Set<String> salutations = DbUtil.getPickListValues(Contact.Salutation).keyset();
            String[] strs = name.split(' ');
            Integer i = 0;
            if(salutations.contains(strs[0])){
                fullname[0] = strs[0]; //salutation
                i = 1;
            }
            if(i < strs.size()) fullname[2] = strs[strs.size()-1]; //lastname
            
            for(Integer j=i; j< strs.size()-1; j++) fullname[1]=(j==i)?strs[j] : fullname[1]+' '+strs[j]; //First name
            
            c.Salutation = fullname[0];
            c.FirstName = fullname[1];
            c.LastName = fullname[2];
        }
    }
    
    public class Post extends JsonPlaceholderObject {
        private String id {get;set;}
        public override String getId(){
            return id;
        }
        private String userId {get; set;} 
        private String title {get; set;}
        private String body {get; set;} 
        
        public override SObject toSObject(){
            return new Post__c(PostId__c=id,UserId__c=userId,Title__c=title,Body__c=body);
        }
    }
    
    public class Comment extends JsonPlaceholderObject {
        private String id {get;set;}
        public override String getId(){
            return id;
        }
        private String postId {get; set;} 
        private String name {get; set;}
        private String body {get; set;} 

        public override SObject toSObject(){
            return new Comment__c(CommentId__c=id,PostId__c=postId,Comment_Name__c=name,Body__c=body);
        }
    }

    public static List<User> getUsers(){
        List<User> users = (List<User>) doGet('/users',List<User>.class);
        return users;
    }
    public static List<Post> getPosts(){
        List<Post> posts = (List<Post>) doGet('/posts',List<Post>.class);
        return posts;
    }
    public static List<Comment> getComments(){
        List<Comment> comments = (List<Comment>) doGet('/comments',List<Comment>.class);
        return comments;
    }
    private static Object doGet(String endpoint, System.Type apexType){
        HttpResponse res = HttpUtil.doGet(getBaseUrl(),endpoint,null);
        if(res.getStatusCode() != 200)
            throw new JsonPlaceholderServiceException(res.getStatus());
        return Json.deserialize(res.getBody(),apexType);
    }
}