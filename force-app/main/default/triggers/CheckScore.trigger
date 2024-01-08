trigger CheckScore on Score__c (before insert, before update) {
    // List<Score__c> listScore = [select Subject__c,Student__c, Term__c from Score__c];
    // Integer indexOfNew = 0;
    // List<Score__c> listScoreNew = Trigger.new;
    // for (Score__c s: Trigger.new)
    // {
    //     indexOfNew ++;
    //     for (Score__c c: listScore)
    //     {
    //         if (c.Subject__c == s.Subject__c 
    //         && c.Student__c == s.Student__c 
    //         && c.Term__c == s.Term__c)
    //         {
    //             s.addError('Score existed');
    //         }
    //     }
    //     for (integer i = 0; i < indexOfNew - 1; i++)
    //     {
    //         if (listScoreNew[i].Subject__c == s.Subject__c 
    //         && listScoreNew[i].Student__c == s.Student__c 
    //         && listScoreNew[i].Term__c == s.Term__c)
    //         {
    //             s.addError('Score existed');
    //         }
    //     }
    // }
}