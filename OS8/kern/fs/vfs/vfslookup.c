#include <defs.h>
#include <string.h>
#include <vfs.h>
#include <inode.h>
#include <error.h>
#include <assert.h>

/*
 * get_device- Common code to pull the device name, if any, off the front of a
 *             path and choose the inode to begin the name lookup relative to.
 */

static int
get_device(char *path, char **subpath, struct inode **node_store) {
    int i, slash = -1, colon = -1;
    // 扫描路径字符串，搜索：和/
    for (i = 0; path[i] != '\0'; i ++) {
        if (path[i] == ':') { colon = i; break; }
        if (path[i] == '/') { slash = i; break; }
    }
    // 不是以/开头且没有devic：前缀----相对路径或裸文件名
    if (colon < 0 && slash != 0) {

        *subpath = path;
        // 起点设为当前目录
        return vfs_get_curdir(node_store);
    }
    // 有device：前缀
    if (colon > 0) {
        // 把设备名与后续路径切断
        path[colon] = '\0';

        // 跳过冒号后面的斜杠
        while (path[++ colon] == '/');
        // subpath指向冒号后面的路径部分
        *subpath = path + colon;
        // 起点设为设备的根
        return vfs_get_root(path, node_store);
    }

    /* *
     * we have either /path or :path
     * /path is a path relative to the root of the "boot filesystem"
     * :path is a path relative to the root of the current filesystem
     * */
    int ret;
    // 以/开头----内核引导文件系统
    if (*path == '/') {
        if ((ret = vfs_get_bootfs(node_store)) != 0) {
            return ret;
        }
    }
    // 以:开头----当前进程文件系统
    else {
        assert(*path == ':');
        struct inode *node;
        if ((ret = vfs_get_curdir(&node)) != 0) {
            return ret;
        }
        /* The current directory may not be a device, so it must have a fs. */
        assert(node->in_fs != NULL);
        *node_store = fsop_get_root(node->in_fs);
        vop_ref_dec(node);
    }

    // 跳过多余的斜杠
    while (*(++ path) == '/');
    *subpath = path;
    return 0;
}

/*
 * vfs_lookup - get the inode according to the path filename
 */
int
vfs_lookup(char *path, struct inode **node_store) {
    int ret;
    struct inode *node;
    // 得到起点路径和子路径
    if ((ret = get_device(path, &path, &node)) != 0) {
        return ret;
    }
    // 解析子路径到目标inode
    if (*path != '\0') {
        ret = vop_lookup(node, path, node_store);
        vop_ref_dec(node);      // 释放节点引用
        return ret;
    }
    *node_store = node;
    return 0;
}

/*
 * vfs_lookup_parent - Name-to-vnode translation.
 *  (In BSD, both of these are subsumed by namei().)
 */
 //向上寻找父目录和文件名
int
vfs_lookup_parent(char *path, struct inode **node_store, char **endp){
    int ret;
    struct inode *node;
    if ((ret = get_device(path, &path, &node)) != 0) {
        return ret;
    }
    *endp = path;        // 子路径指针
    *node_store = node;  // 起点inode
    return 0;
}
