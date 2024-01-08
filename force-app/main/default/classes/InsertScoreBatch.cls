
/**
* Class name        : InsertScoreBatch
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/15
*/
public class InsertScoreBatch implements Database.Batchable<sObject>, Database.Stateful 
{
    BatchLog__c batchLog = new BatchLog__c();
    integer totalScore = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'select id, FullName__c from Student__c';
        batchLog.StartTime__c = System.now();
        batchLog.Status__c = 'Start';
        batchLog.Name = 'Insert Score Batch';
        insert batchLog;
        return Database.getQueryLocator(query);

    }
    public void execute(Database.BatchableContext bc, List<Student__c> student)
    {
        batchLog.Status__c = 'Process';
        batchLog.ExecuteNumber__c = batchLog.ExecuteNumber__c == null ? 0 : batchLog.ExecuteNumber__c;
        batchLog.ExecuteNumber__c = batchLog.ExecuteNumber__c + 1;


        List<Subject__c> listSubject = [select id from Subject__c];
        Integer randomScoreP;
        Integer randomScoreM;
        Integer randomScoreF;
        Integer randomSubject;
        Integer randomNumberSubject;
        Integer randomTerm;
        
        list<Term__c> listTerm = [select id from Term__c];
        list<Score__c> listScore = new List<Score__c>();
        
        
        for (Student__c t: student)
        {
            List<String> listSubjectInTerm = new List<String>();
            randomSubject = Integer.valueof((Math.random() * listSubject.size() *2));
            if (randomSubject < 8)
            {
                randomSubject = 8;
            }

            List<Integer> listSubjectRandom =  new List<Integer>();
            for (Integer k = 0; k < randomSubject; k++)
            {
                randomTerm = Integer.valueof((Math.random() * listTerm.size()));
                randomNumberSubject = Integer.valueof((Math.random() * 8));
                randomScoreP = Integer.valueof((Math.random() * 5));
                randomScoreM = Integer.valueof((Math.random() * 5));
                randomScoreF = Integer.valueof((Math.random() * 5));
                Score__c score = new Score__c(
                    Subject__c = listSubject[randomNumberSubject].Id, 
                    ProcessScore__c = randomScoreP + 5,
                    MidtermScore__c = randomScoreM + 5,
                    FinaltermScore__c = randomScoreF + 5,
                    Student__c = t.Id,
                    Term__c = listTerm[randomTerm].Id
                );
                String subjectTerm = string.valueOf(listSubject[randomNumberSubject].Id) + string.valueOf(listTerm[randomTerm].Id);
                if (listSubjectInTerm.contains(subjectTerm) == false)
                {
                    listSubjectInTerm.add(subjectTerm);
                    listScore.add(score);
                }
            }
            
        }
        insert listScore;
        totalScore += listScore.size();


        //    Database.SaveResult[] SaveResultList = Database.insert(listScore, false);
        //    List<Score__c> exception_List = new List<Score__c>();
        //    for(integer i = 0; i<listScore.size();i++){
        //     If(!SaveResultList[i].isSuccess()){
        //         exception_List.add(listScore[i]);

        //     }
        //  } 
        //  system.debug('exx' + exception_List);

        update batchLog;
        batchLog.ProcessTime__c = System.now();
        batchLog.Content__c = 'Success';
    }
    
    public void finish(Database.BatchableContext bc)
    {
        
        AsyncApexJob batchJob = [SELECT Id, Status, ExtendedStatus, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID =: bc.getJobId() ];
    
        if (batchJob.ExtendedStatus == null )  
        {
            batchLog.Content__c = 'TotalScore: '+totalScore;
        }  
        else 
        {
            batchLog.Content__c = batchJob.ExtendedStatus;
        }    
        batchLog.Status__c = 'Finish';
        batchLog.FinishTime__c = System.now();
        update batchLog;
    }
}

