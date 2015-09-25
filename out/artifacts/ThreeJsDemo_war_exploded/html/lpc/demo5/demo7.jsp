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
            camera.position.set(-30, 40, 50);
            camera.lookAt(new THREE.Vector3(10, 0, 0));

            var renderer = new THREE.WebGLRenderer();
            renderer.setClearColorHex(0xEEEEEE, 0.1);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            var torus = createMesh(new THREE.TorusGeometry(10, 10));
            scene.add(torus);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.radius = torus.children[0].geometry.radius;
                this.tube = torus.children[0].geometry.tube;
                this.radialSegments = torus.children[0].geometry.radialSegments;
                this.tubularSegments = torus.children[0].geometry.tubularSegments;
                this.arc = torus.children[0].geometry.arc;

                this.redraw = function() {
                    scene.remove(torus);
                    torus = createMesh(new THREE.TorusGeometry(
                            controls.radius,
                            controls.tube,
                            Math.round(controls.radialSegments),
                            Math.round(controls.tubularSegments),
                            controls.arc
                    ));
                    scene.add(torus);
                };
            }


            var gui = new dat.GUI();
            gui.add(controls, "radius", 0, 40).onChange(controls.redraw);
            gui.add(controls, "tube", 0, 40).onChange(controls.redraw);
            gui.add(controls, "radialSegments", 0, 40).onChange(controls.redraw);
            gui.add(controls, "tubularSegments", 1, 20).onChange(controls.redraw);
            gui.add(controls, "arc", 0, Math.PI * 2).onChange(controls.redraw);

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
                torus.rotation.y = step += 0.01;
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