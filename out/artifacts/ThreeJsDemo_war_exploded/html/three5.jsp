<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="../js/three.js"></script>
    <script type="text/javascript" src="../js/Stats.js"></script>

    <style>
        div#canvas-frame {
            border: none;
            cursor: pointer;
            width: 100%;
            height: 600px;
            background-color: #EEEEEE;
        }
    </style>

    <script type="text/javascript">
        var renderer;
        var stats;
        function initThree() {
            // 获取窗口宽度
            width = document.getElementById('canvas-frame').clientWidth;
            // 获取窗口高度
            height = document.getElementById('canvas-frame').clientHeight;
            // 创建渲染器
            renderer = new THREE.WebGLRenderer({
                antialias : true
            });
            // 设置宽度高度
            renderer.setSize(width, height);
            // 添加元素
            document.getElementById('canvas-frame').appendChild(renderer.domElement);
            renderer.setClearColorHex(0xFFFFFF, 1.0);

            //  创建性能监视器
            stats = new Stats();
            stats.setMode(0); // 0: fps, 1: ms
            // 将stats的界面对应左上角--设置样式
            stats.domElement.style.position = 'absolute';
            stats.domElement.style.left = '0px';
            stats.domElement.style.top = '0px';
            document.getElementById('canvas-frame').appendChild(stats.domElement);
        }

        var camera;
        // 初始化相机
        function initCamera() {
            // 创建透视相机
            camera = new THREE.PerspectiveCamera(45, width / height, 1, 10000);
            camera.position.x = 0;
            camera.position.y = 0;
            camera.position.z = 600;
            camera.up.x = 0;
            camera.up.y = 1;
            camera.up.z = 0;
            camera.lookAt({
                x : 0,
                y : 0,
                z : 0
            });
        }

        var scene;
        // 创建场景
        function initScene() {
            scene = new THREE.Scene();
        }

        var light;
        // 初始化光
        function initLight() {
//                light = new THREE.AmbientLight(0xFF0000);
//                light.position.set(100, 100, 200);
//                scene.add(light);
            // 创建光源
            light = new THREE.PointLight(0x00FF00);
            light.position.set(0, 0,300);
            scene.add(light);
        }

        var cube;
        var mesh;
        function initObject() {
            var geometry = new THREE.CylinderGeometry( 100,150,400);
            var material = new THREE.MeshLambertMaterial( { color:0xFFFFFF} );
            mesh = new THREE.Mesh( geometry,material);
            mesh.position = new THREE.Vector3(0,0,0);
            scene.add(mesh);
        }

        function threeStart() {
            initThree();
            initCamera();
            initScene();
            initLight();
            initObject();
            animation();

        }
        function animation()
        {
            //renderer.clear();
            //camera.position.x =camera.position.x +1;
            mesh.position.x-=1;
            renderer.render(scene, camera);
            requestAnimationFrame(animation);

            stats.update();
        }
    </script>

</head>
<body onload="threeStart();">
    <div id="canvas-frame"></div>
</body>
</html>