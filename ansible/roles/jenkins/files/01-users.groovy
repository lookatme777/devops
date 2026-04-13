/*
1) Подключить модуль(jenkins.model и всё что к нему относится)
2) Подключить модуль security(hudson.security и всё что к нему относится)
3) Создать instance jenkins'a
4) Создать hudson.realm через new
5) Создать аккаунт (log/pass)
6) Инстанцировать Jenkins новым пользователем
7) Создать стратегию
8) Отключить анонимное чтение
9) Принять стратегию
10) Сохранить
*/

import jenkins.model.Jenkins
import hudson.security.*

def instance = Jenkins.get()

def user = "ansible_jenkins"
def password = "automatic"

// Если security realm не настроен — создаём
if (!(instance.getSecurityRealm() instanceof HudsonPrivateSecurityRealm)) {
    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    instance.setSecurityRealm(hudsonRealm)
}

// Получаем realm
def hudsonRealm = instance.getSecurityRealm()

// Создаём пользователя, если его нет
if (hudsonRealm.getUser(user) == null) {
    hudsonRealm.createAccount(user, password)
}

// Настраиваем стратегию (admin доступ)
def strategy = new GlobalMatrixAuthorizationStrategy()

strategy.add(Jenkins.ADMINISTER, user)

instance.setAuthorizationStrategy(strategy)

instance.save()