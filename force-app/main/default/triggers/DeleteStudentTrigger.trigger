trigger DeleteStudentTrigger on Student__c (after delete) {

    List<Score__c> listScore = new List<Score__c>();
    for (Student__c s: Trigger.old)
    {
        system.debug(s.Id);
    }
    // delete listScore;
}