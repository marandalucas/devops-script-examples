"""
    This class retrieves the list of the cluster's pods.
    It uses the kubernetes Python client to list the pods, authenticating
    using the present kube context.
"""
import sys
from kubernetes import client, config
from kubernetes.client.rest import ApiException

class ClusterInfo:
    """
        A class used to retrieve the list of the cluster's pods.

        ...
        Attributes
        ----------
        auth_method : str
            The method that will be used to authenticate to the Kubernetes cluster. Currently
            only the local kube config method is supported.
        namespace : str
            The list namespace. If not set, gets the list for all anmespaces.

        Methods
        -------
        get()
            Returns the pods list on the specified namespace. If not set, list pods for
            all namespaces
    """
    def __init__(self, auth_method="local", namespace=None):
        self.namespace = namespace
        if auth_method == 'local':
            config.load_kube_config()


    def get(self):
        """
            Returns the pods list on the specified namespace.If not set, list pods for
            all namespaces
        """


        v1_client = client.CoreV1Api()
        configmaps = v1_client.list_namespaced_config_map('kube-system', timeout_seconds=10)

        for item in configmaps.items:
            try:
                cluster = (item.__dict__)['_data']['Corefile']
                if  cluster:
                    cluster_resource = cluster.split(":")
                    cluster_resource_name = cluster_resource[0]
                    return cluster_resource_name
            except:
                pass
