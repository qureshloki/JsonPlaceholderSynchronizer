public class DbUtil {

    public static Map<String,String> getPickListValues(Schema.sObjectField fld){
      Map<String,String> pickListValues= new Map<String,String>();
      Schema.DescribeFieldResult fieldResult = fld.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      for( Schema.PicklistEntry pickListVal : ple){
          pickListValues.put(pickListVal.getValue(),pickListVal.getLabel());
      }  
      return pickListValues;
    }
}