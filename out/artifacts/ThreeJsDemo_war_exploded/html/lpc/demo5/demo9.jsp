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

            var polyhedron = createMesh(new THREE.IcosahedronGeometry(10, 0));
            scene.add(polyhedron);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.radius = 10;
                this.detail = 0;
                this.type = "Icosahedron";

                this.redraw = function() {
                    scene.remove(polyhedron);
                    switch (controls.type) {
                        case "Icosahedron":
                            polyhedron = createMesh(new THREE.IcosahedronGeometry(controls.radius, controls.detail));
                            break;
                        case "Tetrahedron":
                            polyhedron = createMesh(new THREE.TetrahedronGeometry(controls.radius, controls.detail));
                            break;
                        case "Octahedron":
                            polyhedron = createMesh(new THREE.OctahedronGeometry(controls.radius, controls.detail));
                            break;
                        case "Custom":
                            var vertices = [
                                [1, 0, 1],
                                [1, 0, -1],
                                [-1, 0, -1],
                                [-1, 0, 1],
                                [0, 1, 0]
                            ];
                            var faces = [
                                [0, 1, 2, 3],
                                [0, 1, 4],
                                [1, 2, 4],
                                [2, 3, 4],
                                [3, 0, 4]
                            ];
                            polyhedron = createMesh(new THREE.PolyhedronGeometry(vertices, faces, controls.radius, controls.detail));
                            break;
                    }
                    scene.add(polyhedron);
                };
            }

            var gui = new dat.GUI();
            gui.add(controls, "radius", 0, 40).step(1).onChange(controls.redraw);
            gui.add(controls, "detail", 0, 3).step(1).onChange(controls.redraw);
            gui.add(controls, "type", ["Icosahedron", "Tetrahedron", "Octahedron", "Custom"]).onChange(controls.redraw);

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
                polyhedron.rotation.y = step += 0.01;
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