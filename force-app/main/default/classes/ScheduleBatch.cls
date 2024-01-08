public class ScheduleBatch Implements Schedulable
{
    public void execute(SchedulableContext sc)
    {
        updateBirthDayStudent();
    }
     public void updateBirthDayStudent()
     {
        Date minDate = Date.newInstance(1960, 2, 17);
        Date maxDate = Date.today();
        
        List<Student__c> listStudent = [select BirthDay__c from Student__c];
        for (Student__c s: listStudent)
        {
            Integer rangeSize = minDate.daysBetween(maxDate) + 1;
            Decimal daysToAdd = rangeSize * math.random();
            Date result = minDate.addDays(daysToAdd.intValue());
            s.BirthDay__c = result;
        }
        update listStudent;
        

     }
                        

}