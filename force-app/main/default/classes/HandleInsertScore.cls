
/**
* Class name        : HandleInsertScore
* Class description : 
* @created          : Ho Thi Thanh Van aka người yêu bầu trời là kẻ mộng mơ
* @modified         : 2023/08/15
*/
public with sharing class HandleInsertScore 
{

    /**
     * insertScore
     * Insert term - student when score is inserted
     * @param listAllScore
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    public void insertScore(List<Score__c> listAllScore)
    {
        List<Term_Student__c> listTermStudent = [select Id, Student__c, Term__c, TotalScore__c, TotalCredit__c from Term_Student__c];
        Map<String, Term_Student__c> mapTermStudent = new Map<String, Term_Student__c>();
        for (Term_Student__c t : listTermStudent) 
        {
            string mapId = string.valueOf(t.Student__c) + string.valueOf(t.Term__c);
            mapTermStudent.put(mapId, t);
        }
        List<Subject__c> listSubject = [select id, Credit__c from Subject__c];
        Map<Id, Subject__c> mapSubject = new Map<Id, Subject__c>(listSubject);
        try 
        {
            for (Score__c s: listAllScore)
            {
                system.debug(s.Student__c);
                String mapId = string.valueOf(s.Student__c) + String.valueOf(s.Term__c);
                Integer totalCredit = 0;
                Decimal avgScore = 0;
                Integer credit = 0;
                credit = integer.valueOf(mapSubject.get(s.Subject__c).Credit__c);
                    if (mapTermStudent.get(mapId) == null)
                    {
                        Term_Student__c termStudent = new Term_Student__c(Term__c = s.Term__c, 
                                                                            Student__c = s.Student__c, 
                                                                            TotalScore__c = ((s.avgScore__c * credit) /  credit).setScale(2, RoundingMode.HALF_UP),
                                                                            TotalCredit__c = credit);
                        mapTermStudent.put(mapId, termStudent);
                        system.debug(mapTermStudent.get(mapId).TotalScore__c);
                        system.debug(mapTermStudent.get(mapId).TotalCredit__c);
                    }
                    else if (mapTermStudent.get(mapId) != null)
                    {
                        totalCredit = integer.valueOf(mapTermStudent.get(mapId).TotalCredit__c) + credit;
                        mapTermStudent.get(mapId).TotalScore__c = ((mapTermStudent.get(mapId).TotalScore__c*mapTermStudent.get(mapId).TotalCredit__c 
                        + s.avgScore__c*credit) / totalCredit).setScale(2, RoundingMode.HALF_UP);

                        mapTermStudent.get(mapId).TotalCredit__c = totalCredit;
                        system.debug(mapTermStudent.get(mapId).TotalScore__c);
                        system.debug(mapTermStudent.get(mapId).TotalCredit__c);

                    }    
                }
            System.debug(mapTermStudent.values());
           upsert mapTermStudent.values();
        } 
        catch (Exception e) 
        {
            system.debug('loi'+e);
        }
    }


    /** 
     * updateScore
     * Insert term - student when score is inserted
     * @param mapUpdateNew, mapUpdateOld
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    public void updateScore(Map<Id, Score__c> mapUpdateNew, Map<Id, Score__c> mapUpdateOld)
    {
        List<Subject__c> listSubject = [select id, Credit__c from Subject__c];
        Map<Id, Subject__c> mapSubject = new Map<Id, Subject__c>(listSubject);

        List<Term_Student__c> listTermStudent = [select id, Term__c, Student__c, TotalCredit__c, TotalScore__c from Term_Student__c];
        Map<String, Term_Student__c> mapTermStudent = new Map<String, Term_Student__c>();
        for (Term_Student__c t : listTermStudent)
        {
            String mapId = String.valueOf(t.Term__c) + string.valueOf(t.Student__c);
            mapTermStudent.put(mapId, t);
        }
        Integer totalCredit = 0;
        Decimal avgScore = 0;
        Integer credit = 0;
        for (Id key: mapUpdateNew.keySet())
        {
            
            credit = integer.valueOf(mapSubject.get(mapUpdateNew.get(key).Subject__c).Credit__c);
            String mapId = string.valueOf(mapUpdateNew.get(key).Term__c) +  string.valueOf(mapUpdateNew.get(key).Student__c);

            mapTermStudent.get(mapId).TotalScore__c += ((mapUpdateNew.get(key).avgScore__c - mapUpdateOld.get(key).avgScore__c) 
                        * credit / mapTermStudent.get(mapId).TotalCredit__c).setScale(2, RoundingMode.HALF_UP);
        }
        update mapTermStudent.values();
    }


    /** 
     * deleteScore
     * Count avgScore, total credit in term - student when score is deleted
     * @param listDelete
     * @return
     * @created: 2023/08/15 Ho Thi Thanh Van
     * @modified 
     */
    public void deleteScore(List<Score__c> listDelete)
    {
        Map<String, Term_Student__c> mapTermStudent = new Map<String, Term_Student__c>();
        List<Term_Student__c> listTermStudent = [select id, 
                                                        Term__c, 
                                                        Student__c, 
                                                        TotalScore__c, 
                                                        TotalCredit__c 
                                                    from Term_Student__c];

        List<Subject__c> listSubject = [select id, 
                                               Credit__c 
                                            from Subject__c];
        Map<Id, Subject__c> mapSubject = new Map<Id, Subject__c>(listSubject);

        for (Term_Student__c t : listTermStudent)
        {
            String mapId = String.valueOf(t.Term__c) + string.valueOf(t.Student__c);
            mapTermStudent.put(mapId, t);
        }
        for (Score__c s: listDelete)
        {
            string studentId = s.Student__c;
            string termId = s.Term__c;
            string mapId = termId + studentId;

            Integer credit = integer.valueOf(mapSubject.get(s.Subject__c).Credit__c);
            mapTermStudent.get(mapId).TotalScore__c = (mapTermStudent.get(mapId).TotalScore__c
            - s.avgScore__c*credit/mapTermStudent.get(mapId).TotalCredit__c).setScale(1);
            mapTermStudent.get(mapId).TotalCredit__c = mapTermStudent.get(mapId).TotalCredit__c - credit;
        }
        update mapTermStudent.values();
    }
}
    