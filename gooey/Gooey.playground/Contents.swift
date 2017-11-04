import UIKit
import PlaygroundSupport

// sin = opp/hyp
// cos = adj/hyp
// tan = opp/adj

class Point {
	var x: Double
	var y: Double
	let graphicRadius: Double = 2
	lazy var view: UIView = {
		let dot = UIView(frame: CGRect(x: x-graphicRadius, y: y-graphicRadius, width: graphicRadius*2, height: graphicRadius*2))
		dot.backgroundColor = UIColor.red
		dot.layer.cornerRadius = 2
		return dot
	}()
	
	init(x: Double, y: Double) {
		self.x = x
		self.y = y
	}
}

class Circle {
	var center: Point
	var radius: Double
	lazy var view: UIView = {
		let circleView = UIView(frame: CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2))
		circleView.backgroundColor = UIColor.lightGray
		circleView.layer.cornerRadius = CGFloat(radius)
		return circleView
	}()
	
	init(center: Point, radius: Double) {
		self.center = center
		self.radius = radius
	}
	
	func getPoint(forAngle angle: NSMeasurement) -> Point {
		let x = radius*cos(angle.doubleValue)+center.x
		let y = radius*sin(angle.doubleValue)+center.y
		return Point(x: x, y: y)
	}
	
	func getPoint(withStartAngle startAngle: NSMeasurement, forAngle endAngle: NSMeasurement) -> Point {
		let x = radius*cos(endAngle.doubleValue+startAngle.doubleValue)+center.x
		let y = radius*sin(endAngle.doubleValue+startAngle.doubleValue)+center.y
		return Point(x: x, y: y)
	}
	
	func getAngle(forPoint point: Point) -> NSMeasurement {
		return NSMeasurement(doubleValue: atan2(point.y-center.y, point.x-center.x), unit: UnitAngle.radians)
	}
}

func getDistanceBetween(_ point0: Point, _ point1: Point) -> Double {
	return pow(abs(point0.x-point0.x), 2)+pow(abs(point0.y-point1.y), 2)
}



///////////// TESTS /////////////

// set view for tests
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
containerView.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = containerView

// display different angles (0°, 90°, 180°, 270°)
let circles = [Circle(center: Point(x: 100, y: 100), radius: 20),
               Circle(center: Point(x: 200, y: 100), radius: 20),
               Circle(center: Point(x: 300, y: 100), radius: 20),
               Circle(center: Point(x: 400, y: 100), radius: 20)]

for (i, circle) in circles.enumerated() {
	containerView.addSubview(circle.view)
	containerView.addSubview(circle.getPoint(forAngle: NSMeasurement(doubleValue: Double(i)*Double.pi/2, unit: UnitAngle.radians)).view)
	// add point for angle 45° from each angle
	containerView.addSubview(circle.getPoint(withStartAngle: NSMeasurement(doubleValue: Double(i)*Double.pi/2, unit: UnitAngle.radians), forAngle: NSMeasurement(doubleValue: Double.pi/4, unit: UnitAngle.radians)).view)

	let testPoint = Point(x: 250, y: 200)
	containerView.addSubview(testPoint.view)
	var angle = circle.getAngle(forPoint: testPoint)
	print(angle.converting(to: UnitAngle.degrees))
}

