<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/three.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.2.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/dat.gui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/stats.js"></script>

    <title>Insert title here</title>

    <style>
        body {
            /* set margin to 0 and overflow to hidden, to go fullscreen */
            margin: 0;
            overflow: hidden;
        }
    </style>

    <script type="text/javascript">

        $(function() {

            var stats = initStats();

            var scene = new THREE.Scene();

            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.set(-20, 60, 60);
            camera.lookAt(20, 20, 0);

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            var shape = createMesh(new THREE.ShapeGeometry(drawShape()));
            scene.add(shape);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.amount = 2;
                this.bevelThickness = 2;
                this.bevelSize = 0.5;
                this.bevelEnabled = true;
                this.bevelSegments = 3;
                this.bevelEnabled = true;
                this.curveSegments = 12;
                this.steps = 1;

                this.asGeom = function() {
                    scene.remove(shape);

                    var options = {
                        amount: controls.amount,
                        bevelThickness: controls.bevelThickness,
                        bevelSize: controls.bevelSize,
                        bevelSegments: controls.bevelSegments,
                        bevelEnabled: controls.bevelEnabled,
                        curveSegments: controls.curveSegments,
                        steps: controls.steps
                    };
                    shape = createMesh(new THREE.ExtrudeGeometry(drawShape(), options));
                    scene.add(shape);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "amount", 0, 20).onChange(controls.asGeom);
            gui.add(controls, "bevelThickness", 0, 10).onChange(controls.asGeom);
            gui.add(controls, "bevelSize", 0, 10).onChange(controls.asGeom);
            gui.add(controls, "bevelSegments", 0, 30).step(1).onChange(controls.asGeom);
            gui.add(controls, "bevelEnabled").onChange(controls.asGeom);
            gui.add(controls, "curveSegments", 1, 30).step(1).onChange(controls.asGeom);
            gui.add(controls, "steps", 1, 5).onChange(controls.asGeom);
            controls.asGeom();
            render();

            function drawShape() {
                var shape =new THREE.Shape();
                shape.moveTo(10, 10);
                shape.lineTo(10, 10);
                shape.bezierCurveTo(15, 25, 25, 25, 30, 40);

                shape.splineThru([
                        new THREE.Vector2(32, 30),
                        new THREE.Vector2(28, 20),
                        new THREE.Vector2(30, 10)
                ]);

                shape.quadraticCurveTo(20, 15, 10, 10);

                var hole1 = new THREE.Path();
                hole1.absellipse(16, 24, 2, 3, 0, Math.PI * 2, true);
                shape.holes.push(hole1);

                var hole2 = new THREE.Path();
                hole2.absellipse(23, 24, 2, 3, 0, Math.PI * 2, true);
                shape.holes.push(hole2);

                var hole3 = new THREE.Path();
                hole3.absarc(20, 16, 2, 0, Math.PI, true);
                shape.holes.push(hole3);

                return shape;
            }

            function createMesh(geom) {
                geom.applyMatrix(new THREE.Matrix4().makeTranslation(-20, 0, 0));

                var meshMaterial = new THREE.MeshNormalMaterial({transparent: true, opacity: 0.7});

                var wireFrameMat = new THREE.MeshBasicMaterial();
                wireFrameMat.wireframe = true;

                var mesh = new THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial]);
                return mesh;
            }

            function createLine(shape, spaced) {
                if (!spaced) {
                    var mesh = new THREE.Line(shape.createPointsGeometry(), new THREE.LineBasicMaterial({color: 0xff3333, linewidth: 2}));
                    return mesh;
                } else {
                    var mesh = new THREE.Line(shape.createSpacedPointsGeometry(20), new THREE.LineBasicMaterial({color: 0xff3333, linewidth: 2}));
                    return mesh;
                }
            }

            function render() {
                stats.update();
                shape.rotation.y = step += 0.01;
                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = "absolute";
                stats.domElement.style.left = "0px";
                stats.domElement.style.top = "0px";
                $("#Stats-output").append(stats.domElement);
                return stats;
            }

        })

    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>