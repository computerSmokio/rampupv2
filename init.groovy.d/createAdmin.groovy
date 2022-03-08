#!groovy

import jenkins.model.*
import hudson.security.*
import hudson.security.csrf.DefaultCrumbIssuer

def instance = Jenkins.get()
def hudsonR = new HudsonPrivateSecurityRealm(false)

instance.setCrumbIssuer(new DefaultCrumbIssuer(false))
instance.save()

def users =  hudsonR.getAllUsers()
userNames = users.collect{it.toString()}
//Creates admin user if it does not exists
if('admin' in userNames){
    def user = hudson.model.User.get('admin')
    user.addProperty(hudson.security.HudsonPrivateSecurityRealm.Details.fromPlainPassword('pass'))
    user.save()
}else{
    hudsonR.createAccount('admin', 'pass')
    instance.setSecurityRealm(hudsonR)
    def loginStrategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(loginStrategy)
    instance.save()
}
