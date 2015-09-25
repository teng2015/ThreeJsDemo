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


            var renderer;
            var webGLRenderer = new THREE.WebGLRenderer();
            webGLRenderer.setClearColorHex(0xEEEEEE, 1.0);
            webGLRenderer.setSize(window.innerWidth, window.innerHeight);

            webGLRenderer.shadowMapEnabled = true;


            var canvasRenderer = new THREE.CanvasRenderer();

            canvasRenderer.setSize(window.innerWidth, window.innerHeight);

            renderer = webGLRenderer;


            var groundGeom = new THREE.PlaneGeometry(100, 100, 4, 4);
            var groundMesh = new THREE.Mesh(groundGeom, new THREE.MeshBasicMaterial({color: 0x777777}));

            groundMesh.rotation.x = -Math.PI / 2;

            groundMesh.position.y = -20;

            scene.add(groundMesh);


            var sphereGeometry = new THREE.SphereGeometry(14, 20, 20);

            var cubeGeometry = new THREE.CubeGeometry(15, 15, 15);

            var planeGeometry = new THREE.PlaneGeometry(14, 14, 4, 4);


            var meshMaterial = new THREE.MeshNormalMaterial({color: 0x7777ff});

            var sphere = new THREE.Mesh(sphereGeometry, meshMaterial);

            var cube = new THREE.Mesh(cubeGeometry, meshMaterial);

            var plane = new THREE.Mesh(planeGeometry, meshMaterial);

            sphere.position.set(0, 3, 2);

            var sphereFacesLength = sphere.geometry.faces.length;
            for (var i = 0; i < sphereFacesLength; i++) {
                var face = sphere.geometry.faces[i];
                var arrow = new THREE.ArrowHelper(
                        face.normal,
                        face.centroid,
                        2,
                        0x3333FF
                );
                sphere.add(arrow);
            }

            cube.position = sphere.position;
            plane.position = sphere.position;

            scene.add(cube);


            var ambientLight = new THREE.AmbientLight(0x0c0c0c);
            scene.add(ambientLight);


            var spotLight = new THREE.SpotLight(0xffffff);
            spotLight.position.set(-40, 60, -10);
            spotLight.castShadow = true;
            scene.add(spotLight);

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var oldContext = null
            var controls = new function() {
                this.rotationSpeed = 0.02;
                this.bouncingSpeed = 0.03;

                this.opacity = meshMaterial.opacity;
                this.transparent = meshMaterial.transparent;

                this.visible = meshMaterial.visible;
                this.side = "front";

                this.wireframe = meshMaterial.wireframe;
                this.wireframeLinewidth = meshMaterial.wireframeLinewidth;

                this.selectedMesh = "cube";
                this.shadow = "flat";
            }

            var gui = new dat.GUI();
            var spGui = gui.addFolder("Mesh");
            spGui.add(controls, "opacity", 0, 1).onChange(function(e) {
                meshMaterial.opacity = e;
            });
            spGui.add(controls, "transparent").onChange(function(e) {
                meshMaterial.transparent = e;
            });
            spGui.add(controls, "wireframe").onChange(function(e) {
                meshMaterial.wireframe = e;
            });
            spGui.add(controls, "wireframeLinewidth", 0, 20).onChange(function(e) {
                meshMaterial.wireframeLinewidth = e;
            });
            spGui.add(controls, "visible").onChange(function(e) {
                meshMaterial.visible = e;
            });
            spGui.add(controls, "side", ['front', 'back', 'double']).onChange(function(e) {
                console.log(e);
                switch (e) {
                    case "front":
                        meshMaterial.side = THREE.FrontSide;
                        break;
                    case "back":
                        meshMaterial.side = THREE.BackSide;
                        break;
                    case "double":
                        meshMaterial.side = THREE.DoubleSide;
                        break;
                }
                meshMaterial.needsUpdate = true;
            });
            spGui.add(controls, "shadow", ['flat', 'smooth']).onChange(function(e) {
                switch (e) {
                    case "flat":
                        meshMaterial.shading = THREE.FlatShading;
                        break;
                    case "smooth":
                        meshMaterial.shading = THREE.SmoothShading;
                        break;
                }

                var oldPos = sphere.position.clone();
                scene.remove(sphere);
                scene.remove(plane);
                scene.remove(cube);
                sphere = new THREE.Mesh(sphere.geometry.clone(), meshMaterial);
                cube = new THREE.Mesh(cube.geometry.clone(), meshMaterial);
                plane = new THREE.Mesh(plane.geometry.clone(), meshMaterial);

                sphere.position = oldPos;
                cube.position = oldPos;
                plane.position = oldPos;

                switch (controls.selectedMesh) {
                    case "cube":
                        scene.add(cube);
                        break;
                    case "sphere":
                        scene.add(sphere);
                        break;
                    case "plane":
                        scene.add(plane);
                        break;
                }
                meshMaterial.needsUpdate = true;
                console.log(meshMaterial);
            });
            spGui.add(controls, "selectedMesh", ['cube', 'sphere', 'plane']).onChange(function(e) {
                scene.remove(plane);
                scene.remove(cube);
                scene.remove(sphere);

                switch (e) {
                    case "cube":
                        scene.add(cube);
                        break;
                    case "sphere":
                        scene.add(sphere);
                        break;
                    case "plane":
                        scene.add(plane);
                        break;
                }
                scene.add(e);
            });

            render();

            function render() {
                stats.update();

                cube.rotation.y = step += 0.01;
                plane.rotation.y = step;
                sphere.rotation.y = step;

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