"""
@Ceisri
Documentation String: 
isFacingSelf() returns whether or not the rotation angle between the player and their adversary is
within a certain value. Play around with it. It also checks if you have additional directional nodes. 
For example, in my game, enemies don't have a DirectionControl node but players do. 
Remove or keep it depending on your necessities. In my game, the threshold for flank attacks is 30 degrees,
Keep in mind it must be converted from 0.0 to 1.0, to give you a few  examples:

- isFacingSelf(enemy,0.5) returns true only if you are attacking from behind, good for backstabs 
- isFacingSelf(enemy,0.0) returns true if you are attacking from behind or from the sides, good for flank attacks


which means that when the player and adversary are face to face, their rotation degrees 
are between 160 and 180. But when the player is directly behind the adversary, their rotation degree
is between 0 and 15. In your game, it might be exactly the other way around depending on how you 
orient your nodes. Just in case, there's debug.backstab_threshold = angle_between so you can test 
everything.
"""

func isFacingSelf(body:Node, threshold: float) -> bool:
	# Get the global position of the calling object (self)
	var self_global_transform = get_global_transform()
	var self_position = self_global_transform.origin
	# Get the global position of the body
	var body_position = body.global_transform.origin
	# Calculate the direction vector from the calling object (self) to the body
	var direction_to_body = (body_position - self_position).normalized()
	# Get the facing direction of the body from its Mesh node
	var facing_direction = Vector3.ZERO
	var direcion_node = body.get_node("DirectionControl")
	if direcion_node:
		facing_direction = direcion_node.global_transform.basis.z.normalized()
	else:# If DirectionControl node is not found, use the default facing direction of the body
		facing_direction = body.global_transform.basis.z.normalized()
	# Calculate the dot product between the body's facing direction and the direction to the calling object (self)
	var dot_product = -facing_direction.dot(direction_to_body)

	var angle_between = rad2deg(acos(dot_product)) #debug only, feel free to remove
	debug.backstab_treshold=  angle_between #debug only, feel free to remove
	# If the dot product is greater than a certain threshold, consider the body is facing the calling object (self)
	return dot_product >= threshold
