public without sharing class MilestoneTriggerHandler extends TriggerHandler{
    
    public override void afterInsert() {
        MilestoneService.updateProjectCompletion((List<Milestone__c>)Trigger.new);
    }

    public override void afterUpdate() {
        MilestoneService.updateProjectCompletion((List<Milestone__c>)Trigger.new);
    }
}