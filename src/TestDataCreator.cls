public class TestDataCreator {

    public static void createData(){
        createTeachers();
        createStudents();
        createSubjects();
        createEnrollments();
        createSessions();
    }
    public static void createTeachers(){
        List<Contact> teachers = new List<Contact>();
        teachers.add(new Contact(RecordtypeId='0120w0000002UIV', LastName='teacher 1'));
        teachers.add(new Contact(RecordtypeId='0120w0000002UIV', LastName='teacher 2'));
        //insert teachers;
    }
    
    public static void createStudents(){
        List<Contact> students = new List<Contact>();
        students.add(new Contact(RecordtypeId='0120w0000002UIU', LastName='student 1'));
        students.add(new Contact(RecordtypeId='0120w0000002UIU', LastName='student 2'));
        students.add(new Contact(RecordtypeId='0120w0000002UIU', LastName='student 3'));
        students.add(new Contact(RecordtypeId='0120w0000002UIU', LastName='student 4'));
        students.add(new Contact(RecordtypeId='0120w0000002UIU', LastName='student 5'));
        //insert students;
    }
    
    public static void createSubjects(){
        List<Contact> teachers = [select Id from Contact where Name like 'teacher%' order by name];
        list<Subject__c> subjects = new list<Subject__c>();
        subjects.add(new Subject__c(Name='History', Teacher__c=teachers[1].Id));
        subjects.add(new Subject__c(Name='Math', Teacher__c=teachers[0].Id));
        subjects.add(new Subject__c(Name='Science', Teacher__c=teachers[0].Id));
        //insert subjects;
    }
    
    public static void createEnrollments(){
        list<Subject__c> subjects = [select Id from Subject__c order by name];
        List<Contact> students = [select Id from Contact where Name like 'student%' order by name];
        List<Enrollment__c> enrollments = new List<Enrollment__c>();
        enrollments.add(new Enrollment__c(Student__c=students[0].Id,Subject__c=subjects[0].Id));
        enrollments.add(new Enrollment__c(Student__c=students[0].Id,Subject__c=subjects[1].Id));
        enrollments.add(new Enrollment__c(Student__c=students[0].Id,Subject__c=subjects[2].Id));
        
        enrollments.add(new Enrollment__c(Student__c=students[1].Id,Subject__c=subjects[0].Id));
        enrollments.add(new Enrollment__c(Student__c=students[1].Id,Subject__c=subjects[1].Id));
        enrollments.add(new Enrollment__c(Student__c=students[1].Id,Subject__c=subjects[2].Id));
        
        enrollments.add(new Enrollment__c(Student__c=students[2].Id,Subject__c=subjects[0].Id));
        enrollments.add(new Enrollment__c(Student__c=students[2].Id,Subject__c=subjects[1].Id));
        
        enrollments.add(new Enrollment__c(Student__c=students[3].Id,Subject__c=subjects[0].Id));
        enrollments.add(new Enrollment__c(Student__c=students[3].Id,Subject__c=subjects[2].Id));
        
        //insert enrollments;
    }
    
    public static void createSessions(){
        list<Subject__c> subjects = [select Id from Subject__c order by name];
        List<Session__c> sessions = new List<Session__c>();
        Date start = Date.today().toStartofWeek().addDays(-7).addDays(-4);
        for(Date d =start; d <= Date.today().addDays(2); d=d.addDays(1)){
            sessions.add(new Session__c(Subject__c=subjects[0].Id,Session_Date__c=d));
            sessions.add(new Session__c(Subject__c=subjects[1].Id,Session_Date__c=d));
            sessions.add(new Session__c(Subject__c=subjects[2].Id,Session_Date__c=d));
        }
        //insert sessions;        
    }
    
}