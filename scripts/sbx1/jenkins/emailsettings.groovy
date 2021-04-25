import jenkins.model.*

System.setProperty("JENKINS_JAVA_OPTIONS", "-Djava.awt.headless=true -Dmail.smtp.starttls.enable=true")
System.setProperty("JENKINS_ARGS", "-Dmail.smtp.starttls.enable=true")


def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()
jenkinsLocationConfiguration.setAdminAddress("DevBE@rewardinsight.com")
jenkinsLocationConfiguration.save()

def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Mailer")
desc.setSmtpAuth("AKIAIYEFOCLFFIF5RW7A", "[SMTP password]")
desc.setSmtpHost("email-smtp.eu-west-1.amazonaws.com")
desc.setSmtpPort("587")
desc.save()
