trigger InsertScoreTrigger on Score__c (after insert, after update, after delete) 
{
    try 
    {
        InsertScoreInStudent insertScoreInStudent = new InsertScoreInStudent();
        HandleInsertScore handleScore = new HandleInsertScore();
        if (Trigger.isInsert)
        {
            handleScore.insertScore(Trigger.new);
            insertScoreInStudent.updateScoreInStudent(Trigger.new);
        }
        else if (Trigger.isUpdate)
        {
            handleScore.updateScore(Trigger.newMap, Trigger.oldMap);
            insertScoreInStudent.updateScoreInStudent(Trigger.new);
        }
        else if (Trigger.isDelete)
        {
            handleScore.deleteScore(Trigger.old);
            insertScoreInStudent.updateScoreInStudent(Trigger.old);
        }
    } 
    catch (Exception e) 
    {
        system.debug(e);
    }
    
}
