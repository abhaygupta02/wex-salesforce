public class MilestoneService {
    
    public static void updateProjectCompletion(List<Milestone__c> newList) {
        Set<Id> milestoneIds = new Set<Id>();
        List<Project__c> projectListToUpdate = new List<Project__c>();
        for(Milestone__c ms : newList) {
            milestoneIds.add(ms.Project__c);
        }

        for(Project__c proj: [SELECT Id, (SELECT Id, MileStone_Percentage_Completion__c FROM Milestones__r) FROM Project__c WHERE Id IN:milestoneIds]) {
            Double projCompletion = 0;
            Integer count = 0;
            for(MileStone__c ms: proj.MileStones__r) {
                if(ms.MileStone_Percentage_Completion__c != null) {
                    projCompletion += ms.MileStone_Percentage_Completion__c;
                }
                count++;
            }
            Double percentageCompletion = projCompletion / count;
            String status = getStatus(percentageCompletion);
            Project__c project = new project__c(Id = proj.Id, Percentage_Complete__c = percentageCompletion, Status__c = status);
            projectListToUpdate.add(project);
        }

        if(!projectListToUpdate.isEmpty()) {
            update projectListToUpdate;
        }

    }

    public static String getStatus(Double percentageCompletion) {
        if(percentageCompletion == 0) {
            return 'Not Started';
        } else if(percentageCompletion == 100) {
            return 'Complete';
        } else {
            return 'In Progress';
        }
    }
}