"""
    This class retrieves the logs of the cluster's pods.
    It uses the kubernetes Python client to logs the pods, authenticating
    using the present kube context.
"""
import sys
from kubernetes import client, config
from kubernetes.client.rest import ApiException

class PodsLogs:
    """
        A class used to retrieve the logs of the cluster's pods.

        ...
        Attributes
        ----------
        auth_method : str
            The method that will be used to authenticate to the Kubernetes cluster. Currently
            only the local kube config method is supported.
        namespace : str
            The logs namespace. If not set, gets the logs for all anmespaces.

        Methods
        -------
        get()
            Returns the pods logs on the specified namespace. If not set, logs pods for
            all namespaces
    """
    def __init__(self, auth_method="local", namespace=None):
        self.namespace = namespace
        if auth_method == 'local':
            config.load_kube_config()

    def get(self, pod_name, continer_name):
        """
            Returns the pods logs on the specified namespace.If not set, logs pods for
            all namespaces
        """
        v1_client = client.CoreV1Api()
        self.pod_name= pod_name
        self.container_name= continer_name
        try:
            if self.namespace:

                print("Get logs of pod -> ", self.pod_name, "in container name -> ", self.container_name, "in namespace ->" , self.namespace)

                pod_log_output = v1_client.read_namespaced_pod_log(name=self.pod_name, container=self.container_name, namespace=self.namespace, previous=True, _return_http_data_only=True, _preload_content=False)
                pod_log = pod_log_output.data.decode("utf-8")
                return pod_log

        except ApiException as exception:
            print('Exception while logging pods in ->', self.pod_name, exception)
