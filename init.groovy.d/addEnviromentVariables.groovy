import hudson.slaves.EnvironmentVariablesNodeProperty
import jenkins.model.*

def jInstance = Jenkins.get()
def globalNodeProperties = jInstance.getGlobalNodeProperties()
def envVariablesList = globalNodeProperties.getAll(EnvironmentVariablesNodeProperty.class)
def envVariables = null

if(envVariablesList == null || envVariablesList.size() == 0){
    envVariablesList = new EnvironmentVariablesNodeProperty()
    globalNodeProperties.add(envVariablesList)
    envVariables = envVariablesList.getEnvVars()    
}else{
    envVariables = envVariablesList.get(0).getEnvVars()
}

envVariables.addLine('ANSIBLE_HOST_KEY_CHECKING=False')

jInstance.save()