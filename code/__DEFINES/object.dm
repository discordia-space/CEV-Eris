/// Object flags
// A flag denoting that this item should always have a unique melle damages handle(and not use a reference to a centralized one) Will also make any upgrades refresh and reapply
#define OF_UNIQUEMELLEHANDLER 1<<1
// A flag denoting that something else is managing the layer of this object. Not implemented. should stop any layer changes coming from itself
#define OF_LAYERHANDLING 1<<2
// A flag denoting that something else is managing the plane of this objet, Not implemented. should stop any updateIcon changes to planes
#define OF_PLANEHANDLING 1<<3