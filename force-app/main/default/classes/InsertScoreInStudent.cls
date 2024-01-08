
/**
* Class name        : InsertScoreInStudent
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/15
*/

public with sharing class InsertScoreInStudent {

    /**
     * updateScoreInStudent
     * Update avgScore in object student when score is update or inserted or deleted
     * @param listAllScore
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    public void updateScoreInStudent(List<Score__c> listAllScore) 
    {
        List<Id> listIdStudent = new List<Id>();

        for (Score__c score : listAllScore) 
        {   
            if (listIdStudent.contains(score.Student__c) == false)
            {
                listIdStudent.add(score.Student__c);
            }
        }
        List <Student__c> listStudent = [select id, 
                                                FullName__c,
                                                avgScore__c, 
                                                TotalCredit__c 
                                            from Student__c 
                                            where id in: listIdStudent];

        Map <Id, Student__c> mapStudent = new Map<Id, Student__c>(listStudent);

        List<AggregateResult> listMaxScore = [select Subject__c, 
                                                    Student__c,
                                                    MAX(avgScore__c),
                                                    MAX(Subject__r.Credit__c)
                                                from Score__c 
                                                where Student__c in: listIdStudent
                                                group by Subject__c, Student__c];
        Integer credit;

        for (Id key: mapStudent.keySet())
        {
            mapStudent.get(key).avgScore__c = mapStudent.get(key).TotalCredit__c = 0;
        }
        for (integer i = 0; i < listMaxScore.size(); i++)
        {            
            string studentId = string.valueOf(listMaxScore[i].get('Student__c'));
            credit = integer.valueOf(listMaxScore[i].get('expr1'));
                
            mapStudent.get(studentId).TotalCredit__c = mapStudent.get(studentId).TotalCredit__c + credit;
            string strScore = String.valueOf(listMaxScore[i].get('expr0'));
            decimal score = Decimal.valueOf(strScore); 
            mapStudent.get(studentId).avgScore__c = mapStudent.get(studentId).avgScore__c + score*credit;
        }

        for (Id key: mapStudent.keySet())
        {
            if (mapStudent.get(key).TotalCredit__c != 0)
            {
                mapStudent.get(key).avgScore__c = (mapStudent.get(key).avgScore__c / mapStudent.get(key).TotalCredit__c).setScale(2, RoundingMode.HALF_UP);
            }
        }

        update mapStudent.values();
    }
}