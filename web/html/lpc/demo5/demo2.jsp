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
            camera.position.set(-20, 30, 40);
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            var circle = createMesh(new THREE.CircleGeometry(4, 10, 0.3 * Math.PI * 2, 0.3 * Math.PI * 2));
            scene.add(circle);

            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                console.log(circle.children[0].geometry);
                this.radius = 4;
                this.thetaStart = 0.3 * Math.PI * 2;
                this.thetaLength = 0.3 * Math.PI * 2;
                this.segments = 10;
                this.redraw = function() {
                    scene.remove(circle);
                    circle = createMesh(new THREE.CircleGeometry(
                        controls.radius,
                        controls.segments,
                        controls.thetaStart,
                        controls.thetaLength
                    ));
                    scene.add(circle);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "radius", 0, 40).onChange(controls.redraw);
            gui.add(controls, "segments", 0, 40).onChange(controls.redraw);
            gui.add(controls, "thetaStart", 0, 2 * Math.PI).onChange(controls.redraw);
            gui.add(controls, "thetaLength", 0, 2 * Math.PI).onChange(controls.redraw);

            render();

            function createMesh(geom) {
                var meshMaterial = new THREE.MeshNormalMaterial();
                meshMaterial.side = THREE.DoubleSide;
                var wireFrameMat = new THREE.MeshBasicMaterial();
                wireFrameMat.wireframe = true;
                var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);
                return mesh;
            }

            function render() {
                stats.update();
                circle.rotation.y = step += 0.01;
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
        });

    </script>

</head>
<body>

    <div id="Stats-output"></div>

    <div id="WebGL-output"></div>

</body>
</html>