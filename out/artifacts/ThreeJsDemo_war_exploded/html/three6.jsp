<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script type="text/javascript" src="../js/three.js"></script>
    <script type="text/javascript" src="../js/Stats.js"></script>
    <script type="text/javascript" src="../js/Tween.js"></script>

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
            width = document.getElementById('canvas-frame').clientWidth;
            height = document.getElementById('canvas-frame').clientHeight;
            renderer = new THREE.WebGLRenderer({
                antialias : true
            });
            renderer.setSize(width, height);
            document.getElementById('canvas-frame').appendChild(renderer.domElement);
            renderer.setClearColorHex(0xFFFFFF, 1.0);

            stats = new Stats();
            stats.domElement.style.position = 'absolute';
            stats.domElement.style.left = '0px';
            stats.domElement.style.top = '0px';
            document.getElementById('canvas-frame').appendChild(stats.domElement);
        }

        var camera;
        function initCamera() {
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
        function initScene() {
            scene = new THREE.Scene();
        }

        var light;
        function initLight() {

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
            initTween();
            animation();

        }

        // 动画引擎Tween.js
        function initTween() {
            /**
             * @Param to 里面存放的键值对，键x表示mesh.position的x属性，值-400表示，动画结束的时候需要移动到的位置
             * 第二个参数是完成动画需要的时间，这里是3000ms。
             * @Param repeat 表示重复无穷次，也可以接受一个整形数值，例如5次
             * @Param start 开始动画，默认情况下是匀速的将mesh.position.x移动到-400的位置
             */
            new TWEEN.Tween( mesh.position)
                    .to( { x: -400 }, 3000 ).repeat( Infinity ).start();
        }
        function animation()
        {
            renderer.render(scene, camera);
            requestAnimationFrame(animation);

            stats.update();
            TWEEN.update();
        }

    </script>

</head>
<body onload="threeStart();">
    <div></div>
    <div id="canvas-frame"></div>
</body>
</html>