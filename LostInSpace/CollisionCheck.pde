public class CollisionCheck {

    public boolean checkCollision(Player player, Circle circle) {
       
        // Player is a triangle, circle is a sphere
        
        // Get the head point of the 
        
        // Check if the circle is within the triangle
        ArrayList<PVector> vertices = player.getVertices();


        // Check if any of the points is within the circle
        for (PVector vertex : vertices) {
            float distance = vertex.dist(circle.position);
            if (distance < circle.size / 2) {
                return true;
            }
        }

        PVector v1 = vertices.get(0);
        PVector v2 = vertices.get(1);
        PVector v3 = vertices.get(2);

        // Check if the circle is completely within the triangle
        if (((v2.y - v1.y)*(circle.position.x - v1.x) - (v2.x - v1.x)*(circle.position.y - v1.y)) >= 0 && 
            ((v3.y - v2.y)*(circle.position.x - v2.x) - (v3.x - v2.x)*(circle.position.y - v2.y)) >= 0 && 
            ((v1.y - v3.y)*(circle.position.x - v3.x) - (v1.x - v3.x)*(circle.position.y - v3.y)) >= 0) {
            return true;
        }

        // Check if the circle intersects any of the edges

        // Edge 1
        float c1x = circle.position.x - v1.x;
        float c1y = circle.position.y - v1.y;
        float e1x = v2.x - v1.x;
        float e1y = v2.y - v1.y;

        float k = c1x * e1x + c1y * e1y;

        if (k > 0) {
            float len = sqrt(e1x * e1x + e1y * e1y);
            k = k / len;

            if (k < len) {
                if (sqrt(c1x*c1x + c1y * c1y - k*k) <= circle.size / 2) {
                    return true;
                }
            }
        }

        // Edge 2
        float c2x = circle.position.x - v2.x;
        float c2y = circle.position.y - v2.y;
        float e2x = v3.x - v2.x;
        float e2y = v3.y - v2.y;

        k = c2x * e2x + c2y * e2y;

        if (k > 0) {
            float len = sqrt(e2x * e2x + e2y * e2y);
            k = k / len;

            if (k < len) {
                if (sqrt(c2x*c2x + c2y * c2y - k*k) <= circle.size / 2) {
                    return true;
                }
            }
        }

        // Edge 3
        float c3x = circle.position.x - v3.x;
        float c3y = circle.position.y - v3.y;
        float e3x = v1.x - v3.x;
        float e3y = v1.y - v3.y;

        k = c3x*e3x + c3y*e3y;

        if (k > 0)
        {
            float len = sqrt(e3x*e3x + e3y*e3y);
            k = k/len;

            if (k < len)
            {
                if (sqrt(c3x*c3x + c3y*c3y - k*k) <= circle.size / 2)
                return true;
            }
        }

        return false;
    }

    public boolean checkCollision(Circle circle1, Circle circle2) {
        return circle1.position.dist(circle2.position) < circle1.size / 2 + circle2.size / 2;
    }

}