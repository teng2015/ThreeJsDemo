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

            var cube = createMesh(new THREE.CubeGeometry(10, 10, 10));
            scene.add(cube);

            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                console.log(cube.children[0].geometry);

                this.width = cube.children[0].geometry.width;
                this.height = cube.children[0].geometry.height;
                this.depth = cube.children[0].geometry.depth;

                this.widthSegments = cube.children[0].geometry.widthSegments;
                this.heightSegments = cube.children[0].geometry.heightSegments;
                this.depthSegments = cube.children[0].geometry.depthSegments;

                this.redraw = function() {
                    scene.remove(cube);
                    cube = createMesh(new THREE.CubeGeometry(
                            controls.width,
                            controls.height,
                            controls.depth,
                            Math.round(controls.widthSegments),
                            Math.round(controls.heightSegments),
                            Math.round(controls.depthSegments)
                    ));
                    scene.add(cube);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "width", 0, 40).onChange(controls.redraw);
            gui.add(controls, "height", 0, 40).onChange(controls. redraw);
            gui.add(controls, "depth", 0, 40).onChange(controls.redraw);
            gui.add(controls, "widthSegments", 0, 10).onChange(controls. redraw);
            gui.add(controls, "heightSegments", 0, 10).onChange(controls.redraw);
            gui.add(controls, "depthSegments", 0, 10).onChange(controls.redraw);

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
                cube.rotation.y = step += 0.01;
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