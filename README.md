
# Mini Projet - Déploiement Automatisé avec Terraform et Azure

## Description

Ce projet vise à déployer automatiquement une infrastructure sur **Microsoft Azure** à l'aide de **Terraform**. Il inclut la mise en place d'une **machine virtuelle Linux** (Ubuntu) avec une **application web Flask** déployée et accessible via une adresse IP publique. Ce projet est un excellent moyen d'apprendre à automatiser le déploiement d'une application dans le cloud tout en utilisant des outils modernes de gestion d'infrastructure comme Terraform.

## Architecture

L'architecture de ce projet comprend les éléments suivants :
1. **Resource Group** : Un groupe de ressources Azure pour organiser les ressources.
2. **Virtual Network** : Un réseau virtuel pour connecter toutes les ressources.
3. **Subnet** : Un sous-réseau pour déployer la machine virtuelle.
4. **Public IP** : Une adresse IP publique pour accéder à l'application Flask déployée.
5. **Network Interface** : Une interface réseau pour la machine virtuelle afin qu'elle puisse communiquer avec le réseau et l'Internet.
6. **Linux Virtual Machine** : Une machine virtuelle Ubuntu 22.04, configurée avec Gunicorn pour exécuter l'application Flask.
7. **Application Flask** : Une application web simple déployée et accessible via le port 5000 de la machine virtuelle.

## Prérequis

Avant de démarrer, assurez-vous d'avoir les outils suivants installés :
- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Un compte **Microsoft Azure** avec les autorisations nécessaires pour créer des ressources.
- [Git](https://git-scm.com/)
- [Python](https://www.python.org/) avec **Flask** et **Gunicorn** installés sur la machine virtuelle.

## Configuration

### 1. Cloner le projet

Clonez ce projet sur votre machine locale avec la commande suivante :

```bash
git clone https://github.com/LaSkyMania/H3-CLOUD-COMPUTING.git
cd H3-CLOUD-COMPUTING
```

### 2. Initialiser Terraform

Avant de commencer à déployer l'infrastructure, vous devez initialiser Terraform pour télécharger les plugins nécessaires.

```bash
terraform init
```

### 3. Configurer les variables

Dans le fichier `terraform.tfvars`, vous pouvez spécifier des variables comme le nom du groupe de ressources, la région, et les identifiants administratifs pour la machine virtuelle :

```hcl
resource_group_name = "myResourceGroup"
location            = "East US"
vm_name             = "flask-vm"
admin_username      = "azureuser"
admin_password      = "your_password_here"
```

### 4. Déployer l'infrastructure

Lancez la commande suivante pour créer l'infrastructure dans Azure :

```bash
terraform apply
```

Cela va créer toutes les ressources nécessaires : groupe de ressources, réseau virtuel, sous-réseau, adresse IP publique, machine virtuelle, etc. Terraform vous demandera de confirmer les actions à entreprendre. Tapez `yes` pour commencer le déploiement.

### 5. Accéder à l'application Flask

Une fois le déploiement terminé, vous pouvez accéder à votre application Flask en vous connectant à l'adresse IP publique fournie par Terraform (par exemple, `http://<public_ip>:5000`). Cette adresse est disponible dans les sorties Terraform après le déploiement.

### 6. Déployer l'application Flask

L'application Flask est déployée à l'aide de **Gunicorn**, un serveur WSGI pour Python. Voici comment elle est configurée pour démarrer sur la machine virtuelle :

```bash
gunicorn --bind 0.0.0.0:5000 app:app
```

Assurez-vous que Flask est installé et que le fichier `app.py` est présent dans le répertoire `/home/azureuser` sur la machine virtuelle.

### 7. Nettoyer l'infrastructure

Après avoir testé l'application, vous pouvez supprimer l'infrastructure en toute sécurité en utilisant Terraform :

```bash
terraform destroy
```

## Structure du Projet

Voici la structure des fichiers du projet :

```
H3-CLOUD-COMPUTING/
├── app.py                    # Application Flask
├── main.tf                   # Configuration principale de Terraform
├── terraform.tfvars          # Fichier de configuration des variables
├── outputs.tf                # Définition des sorties Terraform (IP publique, etc.)
├── variables.tf              # Définition des variables Terraform
├── README.md                 # Documentation du projet
```

## Conclusion

Ce projet est un bon moyen d'automatiser le déploiement d'une application web Flask dans le cloud en utilisant **Terraform**. Grâce à cette approche, vous pouvez facilement déployer et gérer l'infrastructure de vos applications de manière cohérente et reproductible. Terraform et Azure offrent une solution puissante et flexible pour le déploiement d'applications dans le cloud.

## Ressources supplémentaires

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Flask Documentation](https://flask.palletsprojects.com/)