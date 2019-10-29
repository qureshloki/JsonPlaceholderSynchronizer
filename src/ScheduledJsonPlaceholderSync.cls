/*Schedulabe job that can be scheduled to run daily*/
public class ScheduledJsonPlaceholderSync implements Schedulable {
    
    public void execute(SchedulableContext SC) {
    	new JsonPlaceholderSynchronizer().sync();
	}

}