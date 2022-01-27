// CREDITS
/*
 Initial code credit for this goes to Uristqwerty.
 Debugging, functionality, all comments and porting by Giacom.

 Everything about freelook (or what we can put in here) will be stored here.


 WHAT IS THIS?

 This is a replacement for the current camera69ovement system, of the AI. Before this, the AI had to69ove between cameras and could
 only see what the cameras could see.69ot only this but the cameras could see through walls, which created problems.
 With this, the AI controls an "AI Eye"69ob, which69oves just like a ghost; such as69oving through walls and being invisible to players.
 The AI's eye is set to this69ob and then we use a system (explained below) to determine what the cameras around the AI Eye can and
 cannot see. If the camera cannot see a turf, it will black it out, otherwise it won't and the AI will be able to see it.
 This creates several features, such as..69o69ore see-through-wall cameras, easier to control camera69ovement, easier tracking,
 the AI only being able to track69obs which are69isible to a camera, only trackable69obs appearing on the69ob list and69any69ore.


 HOW IT WORKS

 It works by first creating a camera69etwork datum. Inside of this camera69etwork are "chunks" (which will be
 explained later) and "cameras". The cameras list is kept up to date by obj/machinery/camera/New() and Destroy().

69ext the camera69etwork has chunks. These chunks are a 16x16 tile block of turfs and cameras contained inside the chunk.
 These turfs are then sorted out based on what the cameras can and cannot see. If69one of the cameras can see the turf, inside
 the 16x16 block, it is listed as an "obscured" turf.69eaning the AI won't be able to see it.


 HOW IT UPDATES

 The camera69etwork uses a streaming69ethod in order to effeciently update chunks. Since the server will have doors opening, doors closing,
 turf being destroyed and other lag inducing stuff, we want to update it under certain conditions and69ot every tick.

 The chunks are69ot created straight away, only when an AI eye69oves into it's area is when it gets created.
 One a chunk is created, when a69on glass door opens/closes or an opacity turf is destroyed, we check to see if an AI Eye is looking in the area.
 We do this with the "seenby" list, which updates everytime an AI is69ear a chunk. If there is an AI eye inside the area, we update the chunk
 that the changed atom is inside and all surrounding chunks, since a camera's69ision could leak onto another chunk. If there is69o AI Eye, we instead
 flag the chunk to update whenever it is loaded by an AI Eye. This is basically how the chunks update and keep it in sync. We then add some lag reducing
69easures, such as an UPDATE_BUFFER which stops a chunk from updating too69any times in a certain time-frame, only updating if the changed atom was blocking
 sight; for example, we don't update glass airlocks or floors.


 WHERE IS EVERYTHING?

 cameranet.dm	=	Everything about the cameranet datum.
 chunk.dm		=	Everything about the chunk datum.
 eye.dm			=	Everything about the AI and the AIEye.
 updating.dm	=	Everything about triggers that will update chunks.

*/