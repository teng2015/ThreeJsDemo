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

    <script type="text/javascript">

        $(function() {

            // 调用帧插件
            var stats = initStats();

            // 创建一个场景
            var scene = new THREE.Scene();
            // 创建一个相机
            var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
            camera.position.set(-30, 40, 30);
            camera.lookAt(scene.position);

            // 创建渲染器
            var renderer = new THREE.WebGLRenderer();
            // 设置背景和透明度
            renderer.setClearColorHex(0xEEEEEE, 1.0);
            // 设置宽度和高度
            renderer.setSize(window.innerWidth, window.innerHeight);
            // 是否允许阴影映射
            renderer.shadowMapEnabled = true;

            // 创建立方体
            var planeGeometry = new THREE.PlaneGeometry(60, 40, 1, 1);
            var planeMaterial = new THREE.MeshLambertMaterial({color: 0xffffff});
            var plane = new THREE.Mesh(planeGeometry, planeMaterial);
            // 是否支持阴影覆盖
            plane.receiveShadow = true;
            plane.rotation.x = -0.5 * Math.PI;
            plane.position.set(0, 0, 0);
            scene.add(plane);

            // 创建光源（环境光）
            var ambientLight = new THREE.AmbientLight(0x0c0c0c);
            scene.add(ambientLight);

            // 创建光源（聚光灯光源）
            var spotLight = new THREE.SpotLight( 0xffffff );
            spotLight.position.set( -40, 60, -10 );
            spotLight.castShadow = true;
            scene.add( spotLight );

            $("#WebGL-output").append(renderer.domElement);

            var step = 0;
            var controls = new function() {
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
                    var cubeSize = Math.ceil((Math.random() * 3));
                    var cube = new THREE.Mesh(new THREE.CubeGeometry(cubeSize, cubeSize, cubeSize),
                        new THREE.MeshLambertMaterial({
                            color: Math.random() * 0xffffff
                        })
                    );
                    cube.castShadow = true;
                    cube.name = "cube-" + scene.children.length;

                    cube.position.x=-30 + Math.round((Math.random() * planeGeometry.width));
                    cube.position.y= Math.round((Math.random() * 5));
                    cube.position.z=-20 + Math.round((Math.random() * planeGeometry.height));

                    scene.add(cube);
                    this.numberOfObjects = scene.children.length;
                }

                this.outputObjects = function() {
                    console.log(scene.children);
                }
            }

            var gui = new dat.GUI();
            gui.add(controls, 'rotationSpeed', 0, 0.5);
            gui.add(controls, 'addCube');
            gui.add(controls, 'removeCube');
            gui.add(controls, 'outputObjects');
            gui.add(controls, 'numberOfObjects').listen();

            render();

            // 渲染
            function render() {
                stats.update();

                scene.traverse(function(e) {
                    if (e instanceof THREE.Mesh && e != plane ) {
                        e.rotation.x+=controls.rotationSpeed;
                        e.rotation.y+=controls.rotationSpeed;
                        e.rotation.z+=controls.rotationSpeed;
                    }
                });

                requestAnimationFrame(render);
                renderer.render(scene, camera);
            }

            // 帧插件
            function initStats() {
                var stats = new Stats();
                stats.setMode(0);
                stats.domElement.style.position = 'absolute';
                stats.domElement.style.left = '0px';
                stats.domElement.style.top = '0px';

                $("#Stats-output").append( stats.domElement );
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