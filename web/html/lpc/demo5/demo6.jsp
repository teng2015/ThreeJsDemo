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
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.shadowMapEnabled = true;

            var cylinder = createMesh(new THREE.CylinderGeometry(20, 20, 20));
            scene.add(cylinder);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.radiusTop = 20;
                this.radiusBottom = 20;
                this.height = 20;

                this.segmentsX = 8;
                this.segmentsY = 1;

                this.openEnded = false;
                this.redraw = function() {
                    scene.remove(cylinder);
                    cylinder = createMesh(new THREE.CylinderGeometry(
                        controls.radiusTop,
                        controls.radiusBottom,
                        controls.height,
                        controls.segmentsX,
                        controls.segmentsY,
                        controls.openEnded
                    ));
                    scene.add(cylinder);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "radiusTop", -40, 40).onChange(controls.redraw);
            gui.add(controls, "radiusBottom", -40, 40).onChange(controls.redraw);
            gui.add(controls, "height", 0, 40).onChange(controls.redraw);
            gui.add(controls, "segmentsX", 1, 20).step(1).onChange(controls.redraw);
            gui.add(controls, "segmentsY", 1, 20).step(1).onChange(controls.redraw);
            gui.add(controls, "openEnded").onChange(controls.redraw);

            render();

            function createMesh(geom) {
                var meshMaterial = new THREE.MeshNormalMaterial();
                meshMaterial.side = THREE.DoubleSide;
                var wireFrameMat = new THREE.MeshBasicMaterial();
                wireFrameMat.wireframe = true;

                var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat])
                return mesh;
            }

            function render() {
                stats.update();
                cylinder.rotation.y = step += 0.01;
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