Colliders = {}

Colliders.isCollidingWith = function(obj1, obj2)
	return obj1.x + obj1.w * obj1.sX / 2 >= obj2.x
        and obj1.x - obj1.w * obj1.sX / 2 <= obj2.x + obj2.w * obj2.sX
        and obj1.y + obj1.h * obj1.sY / 2 >= obj2.y
        and obj1.y <= obj2.y + obj2.h * obj2.sY
end
