trigger MilestoneTrigger on Milestone__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    new MilestoneTriggerHandler().run(Trigger_Setting__c.Disable_Milestone_Trigger__c);
}