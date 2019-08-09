# General Notes

CSI like the others (CRI, CNI.. etc) benefits the CxI vendors and CO vendors and by that the Kube Users. CSI brings Volume Plugin Portability between CO vendors as SPs need to only write one Plugin that complies with CSI after this - Any CO that implements CSI can now work with the SPs Plugin.


Spec for CSI [is here](https://github.com/container-storage-interface/spec/blob/master/spec.md)
Ref [from here](https://medium.com/google-cloud/understanding-the-container-storage-interface-csi-ddbeb966a3b)
Writin a [CSI plugin](https://arslan.io/2018/06/21/how-to-write-a-container-storage-interface-csi-plugin/)

## Pre CSI Storage Provisioning
1. Volume plugin development is tightly coupled and dependent on Kubernetes releases.
2. Kubernetes developers/community are responsible for testing and maintaining all volume plugins, *instead of just testing and maintaining a stable plugin API.*
3. Bugs in volume plugins can crash critical Kubernetes components, instead of just the plugin.
4. Volume plugins get full privileges of kubernetes components (kubelet and kube-controller-manager).
5. Plugin developers are forced to make plugin source code available, and can not choose to release just a binary.

![Pre CSI](images/preCSI.png?raw=true "Pre CSI")


## CSI Design Goals (MVP):
1. Enable SP authors to write one CSI compliant Plugin that “just works” across all COs that implement CSI.
   SP: Storage Provider, the vendor of a CSI plugin implementation.
   CO: Container Orchestration system, communicates with Plugins using CSI service RPCs.
2. Define API (RPCs) that enable:
	Dynamic provisioning and deprovisioning of a volume.
	Attaching or detaching a volume from a node.
	Mounting/unmounting a volume from a node.
	Consumption of both block and mountable volumes.
	Local storage providers (e.g., device mapper, lvm).
	Creating and deleting a snapshot (source of the snapshot is a volume).
	Provisioning a new volume from a snapshot (reverting snapshot, where data in the original volume is erased and replaced with data in the snapshot, is out of scope).

Note: CSI is positioned as a replacement for FlexVolumes.

![CSI](images/csi.png?raw=true "CSI")

### Kubernetes external component:
1. This is completely implemented and maintained by the Kubernetes team. These extend kubernetes actions outside of kubernetes. The SP vendors need not worry about the implementation details of this at all.
2. Components:
a. Driver registrar — is a sidecar container that registers the CSI driver with kubelet, and adds the drivers custom NodeId to a label on the Kubernetes Node API Object. It does this by communicating with the Identity service on the CSI driver and also calling the CSI GetNodeId operation.
b. External provisioner — is a sidecar container that watches Kubernetes PersistentVolumeClaim objects and triggers CSI CreateVolume and DeleteVolume operations against a driver endpoint.
c. External attacher — is a sidecar container that watches Kubernetes VolumeAttachment objects and triggers CSI ControllerPublish and ControllerUnpublish operations against a driver endpoint

### Storage vendor/3rd-party external component:
This is a vendor specific implementation. Each vendor should implement their respective APIs into gRPC service functions. There are 3 components:
1. CSI Identity — is mainly for identifying the plugin service, making sure it’s healthy, and returning basic information about the plugin itself.
2. CSI Controller — is responsible of controlling and managing the volumes, such as: creating, deleting, attaching/detaching, snapshotting, etc.
3. CSI Node — is responsible for controllong volume’s action in the kubernetes node ex: NodeGetVolumeStats, NodePublishVolume (mount the volume from staging to target path), NodeStageVolume (temporarily mount the volume to a staging path)
