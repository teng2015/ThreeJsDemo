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
            scene.overrideMaterial = new THREE.MeshDepthMaterial();


            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 10, 130);

            camera.position.set(-50, 40, 50);

            camera.lookAt(scene.position);



            var renderer = new THREE.WebGLRenderer();

            renderer.setClearColorHex(0x000000, 1.0);

            renderer.setSize(window.innerWidth, window.innerHeight);

            renderer.shadowMapEnabled = true;


            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
                this.cameraNear = camera.near;
                this.cameraFar = camera.far;
                this.rotationSpeed = 0.02;
                this.numberOfObjects = scene.children.length;

                this.removeCube = function () {
                    var allChildren = scene.children;
                    var lastObject = allChildren[allChildren.length - 1];
                    if (lastObject instanceof THREE.Mesh) {
                        scene.remove(lastObject);
                        this.numberOfObjects = scene.children.length;
                    }
                }

                this.addCube = function() {
                    var cubeSize = Math.ceil(3 + (Math.random() * 3));
                    var cubeGeometry = new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize);
                    var cubeMaterial = new THREE.MeshLambertMaterial({color: Math.random() * 0xffffff});
                    var cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
                    cube.castShadow = true;

                    cube.position.x = -60 + Math.round((Math.random() * 100));
                    cube.position.y = Math.round((Math.random() * 10));
                    cube.position.z = -100 + Math.round((Math.random() * 150));

                    scene.add(cube);
                    this.numberOfObjects = scene.children.length;
                };

                this.outputObjects = function () {
                    console.log(scene.children);
                }
            }


            var gui = new dat.GUI();
            gui.add(controls, 'rotationSpeed', 0, 0.5);
            gui.add(controls, 'addCube');
            gui.add(controls, 'removeCube');
            gui.add(controls, 'cameraNear', 0, 50).onChange(function (e) {
                camera.near = e;
            });
            gui.add(controls, 'cameraFar', 50, 200).onChange(function (e) {
                camera.far = e;
            });


            render();

            function render() {
                stats.update();
                scene.traverse(function (e) {
                    if (e instanceof THREE.Mesh) {
                        e.rotation.x += controls.rotationSpeed;
                        e.rotation.y += controls.rotationSpeed;
                        e.rotation.z += controls.rotationSpeed;
                    }
                });

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