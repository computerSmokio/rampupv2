#!groovy

import jenkins.model.*

def defaultPlugins = "docker-workflow ant build-timeout credentials-binding github-organization-folder gradle workflow-aggregator ssh-slaves subversion timestamper ws-cleanup"
def userPlugins = "docker docker-pipeline amazon-ecr ansible pipeline-utility-steps"

def plugins = defaultPlugins.split() + userPlugins.split()

def jInstance = Jenkins.get()
def pluginMan = jInstance.getPluginManager()
def updateCenter = jInstance.getUpdateCenter()
def installed = false
def initialized = false

plugins.each{
    if(!pluginMan.getPlugin(it)){
        if(!initialized){
            updateCenter.updateAllSites()
            initialized = true
        }
        def plugin = updateCenter.getPlugin(it)
        if(plugin){
            def installation = plugin.deploy()
            while(!installation.isDone()){
            }
            installed = true
        }
    }
}

if(installed){
    jInstance.save()
    jInstance.restart()
}
