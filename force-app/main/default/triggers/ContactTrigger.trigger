trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
    
    List<Contact> contacts = Trigger.isDelete ? Trigger.old : Trigger.new;
    Set<Id> acctIds = new Set<Id>();
   
    for (Contact c : contacts) {     
        if (c.AccountId != null) {
            acctIds.add(c.AccountId);
        }
    }
   
    List<Account> acctsToRollup = new List<Account>();
    for (AggregateResult ar : [SELECT AccountId AcctId, Count(id) CC 
                               FROM Contact 
                               WHERE AccountId in: acctIds 
                               GROUP BY AccountId]){
        Account a = new Account();
        a.Id = (Id) ar.get('AcctId'); 
        a.Contact_Count__c = (Integer) ar.get('CC');
        acctsToRollup.add(a);
    }
        
	//System.debug(acctsToRollup); 	
    update acctsToRollup;

}