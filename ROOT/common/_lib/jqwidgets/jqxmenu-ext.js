/*
jQWidgets v3.5.0 (2014-Sep-15)
Copyright (c) 2011-2014 jQWidgets.
License: http://jqwidgets.com/license/
*/
(function(a) {
    a.extend(a.jqx._jqxMenu.prototype, {
        _openItem: function(t, s, r) {
            if (t == null || s == null) {
                return false
            }
            if (s.isOpen) {
                return false
            }
            if (s.disabled) {
                return false
            }
            if (t.disabled) {
                return false
            }
            var m = t.popupZIndex;
            if (r != undefined) {
                m = r
            }
            var e = t.animationHideDuration;
            t.animationHideDuration = 0;
            t._closeItem(t, s, true, true);
            t.animationHideDuration = e;
            //this.host.focus();		// 2018.06.27 신현삼. jqxMenu에서 마우스오버시 팝업창의 포커스를 잃는 버그 픽스
            var f = [5, 5];
            var u = a(s.subMenuElement);
            if (u != null) {
                u.stop()
            }
            if (u.data("timer").hide != null) {
                clearTimeout(u.data("timer").hide)
            }
            var p = u.closest("div.jqx-menu-popup");
            var h = a(s.element);
            var j = s.level == 0 ? this._getOffset(s.element) : h.position();
            if (s.level > 0 && this.hasTransform) {
                var q = parseInt(h.coord().top) - parseInt(this._getOffset(s.element).top);
                j.top += q
            }
            if (s.level == 0 && this.mode == "popup") {
                j = h.coord()
            }
            var k = s.level == 0 && this.mode == "horizontal";
            var b = k ? j.left : this.menuElements[s.parentId] != null && this.menuElements[s.parentId].subMenuElement != null ? parseInt(a(a(this.menuElements[s.parentId].subMenuElement).closest("div.jqx-menu-popup")).outerWidth()) - f[0] : parseInt(u.outerWidth());
            p.css({
                visibility: "visible",
                display: "block",
                left: b,
                top: k ? j.top + h.outerHeight() : j.top,
                zIndex: m
            });
            u.css("display", "block");
            if (this.mode != "horizontal" && s.level == 0) {
                var d = this._getOffset(this.element);
                p.css("left", -1 + d.left + this.host.outerWidth());
                u.css("left", -u.outerWidth())
            } else {
                var c = this._getClosedSubMenuOffset(s);
                u.css("left", c.left);
                u.css("top", c.top)
            }
            p.css({
                height: parseInt(u.outerHeight()) + parseInt(f[1]) + "px"
            });
            var o = 0;
            var g = 0;
            switch (s.openVerticalDirection) {
                case "up":
                    if (k) {
                        u.css("top", u.outerHeight());
                        o = f[1];
                        var l = parseInt(u.parent().css("padding-bottom"));
                        if (isNaN(l)) {
                            l = 0
                        }
                        if (l > 0) {
                            p.addClass(this.toThemeProperty("jqx-menu-popup-clear"))
                        }
                        u.css("top", u.outerHeight() - l);
                        p.css({
                            display: "block",
                            top: j.top - p.outerHeight(),
                            zIndex: m
                        })
                    } else {
                        o = f[1];
                        u.css("top", u.outerHeight());
                        p.css({
                            display: "block",
                            top: j.top - p.outerHeight() + f[1] + h.outerHeight(),
                            zIndex: m
                        })
                    }
                    break;
                case "center":
                    if (k) {
                        u.css("top", 0);
                        p.css({
                            display: "block",
                            top: j.top - p.outerHeight() / 2 + f[1],
                            zIndex: m
                        })
                    } else {
                        u.css("top", 0);
                        p.css({
                            display: "block",
                            top: j.top + h.outerHeight() / 2 - p.outerHeight() / 2 + f[1],
                            zIndex: m
                        })
                    }
                    break
            }
            switch (s.openHorizontalDirection) {
                case this._getDir("left"):
                    if (k) {
                        p.css({
                            left: j.left - (p.outerWidth() - h.outerWidth() - f[0])
                        })
                    } else {
                        g = 0;
                        u.css("left", p.outerWidth());
                        p.css({
                            left: j.left - (p.outerWidth()) + 2 * s.level
                        })
                    }
                    break;
                case "center":
                    if (k) {
                        p.css({
                            left: j.left - (p.outerWidth() / 2 - h.outerWidth() / 2 - f[0] / 2)
                        })
                    } else {
                        p.css({
                            left: j.left - (p.outerWidth() / 2 - h.outerWidth() / 2 - f[0] / 2)
                        });
                        u.css("left", p.outerWidth())
                    }
                    break
            }
            if (k) {
                if (parseInt(u.css("top")) == o) {
                    s.isOpen = true;
                    return
                }
            } else {
                if (parseInt(u.css("left")) == g) {
                    s.isOpen == true;
                    return
                }
            }
            a.each(t._getSiblings(s), function() {
                t._closeItem(t, this, true, true)
            });
            var n = a.data(t.element, "animationHideDelay");
            t.animationHideDelay = n;
            if (this.autoCloseInterval > 0) {
                if (this.host.data("autoclose") != null && this.host.data("autoclose").close != null) {
                    clearTimeout(this.host.data("autoclose").close)
                }
                if (this.host.data("autoclose") != null) {
                    this.host.data("autoclose").close = setTimeout(function() {
                        t._closeAll()
                    }, this.autoCloseInterval)
                }
            }
            u.data("timer").show = setTimeout(function() {
                if (p != null) {
                    if (k) {
                        u.stop();
                        u.css("left", g);
                        if (!a.jqx.browser.msie) {}
                        h.addClass(t.toThemeProperty("jqx-fill-state-pressed"));
                        h.addClass(t.toThemeProperty("jqx-menu-item-top-selected"));
                        if (s.openVerticalDirection == "down") {
                            a(s.element).addClass(t.toThemeProperty("jqx-rc-b-expanded"));
                            p.addClass(t.toThemeProperty("jqx-rc-t-expanded"))
                        } else {
                            a(s.element).addClass(t.toThemeProperty("jqx-rc-t-expanded"));
                            p.addClass(t.toThemeProperty("jqx-rc-b-expanded"))
                        }
                        var v = a(s.arrow);
                        if (v.length > 0 && t.showTopLevelArrows) {
                            v.removeClass();
                            if (s.openVerticalDirection == "down") {
                                v.addClass(t.toThemeProperty("jqx-menu-item-arrow-down-selected"));
                                v.addClass(t.toThemeProperty("jqx-icon-arrow-down"))
                            } else {
                                v.addClass(t.toThemeProperty("jqx-menu-item-arrow-up-selected"));
                                v.addClass(t.toThemeProperty("jqx-icon-arrow-up"))
                            }
                        }
                        if (t.animationShowDuration == 0) {
                            u.css({
                                top: o
                            });
                            s.isOpen = true;
                            t._raiseEvent("0", s);
                            a.jqx.aria(a(s.element), "aria-expanded", true)
                        } else {
                            u.animate({
                                top: o
                            }, t.animationShowDuration, t.easing, function() {
                                s.isOpen = true;
                                a.jqx.aria(a(s.element), "aria-expanded", true);
                                t._raiseEvent("0", s)
                            })
                        }
                    } else {
                        u.stop();
                        u.css("top", o);
                        if (!a.jqx.browser.msie) {}
                        if (s.level > 0) {
                            h.addClass(t.toThemeProperty("jqx-fill-state-pressed"));
                            h.addClass(t.toThemeProperty("jqx-menu-item-selected"));
                            var v = a(s.arrow);
                            if (v.length > 0) {
                                v.removeClass();
                                if (s.openHorizontalDirection != "left") {
                                    v.addClass(t.toThemeProperty("jqx-menu-item-arrow-" + t._getDir("right") + "-selected"));
                                    v.addClass(t.toThemeProperty("jqx-icon-arrow-" + t._getDir("right")))
                                } else {
                                    v.addClass(t.toThemeProperty("jqx-menu-item-arrow-" + t._getDir("left") + "-selected"));
                                    v.addClass(t.toThemeProperty("jqx-icon-arrow-" + t._getDir("left")))
                                }
                            }
                        } else {
                            h.addClass(t.toThemeProperty("jqx-fill-state-pressed"));
                            h.addClass(t.toThemeProperty("jqx-menu-item-top-selected"));
                            var v = a(s.arrow);
                            if (v.length > 0) {
                                v.removeClass();
                                if (s.openHorizontalDirection != "left") {
                                    v.addClass(t.toThemeProperty("jqx-menu-item-arrow-" + t._getDir("right") + "-selected"));
                                    v.addClass(t.toThemeProperty("jqx-icon-arrow-" + t._getDir("right")))
                                } else {
                                    v.addClass(t.toThemeProperty("jqx-menu-item-arrow-" + t._getDir("left") + "-selected"));
                                    v.addClass(t.toThemeProperty("jqx-icon-arrow-" + t._getDir("left")))
                                }
                            }
                        }
                        if (!a.jqx.browser.msie) {}
                        if (t.animationShowDuration == 0) {
                            u.css({
                                left: g
                            });
                            t._raiseEvent("0", s);
                            s.isOpen = true;
                            a.jqx.aria(a(s.element), "aria-expanded", true)
                        } else {
                            u.animate({
                                left: g
                            }, t.animationShowDuration, t.easing, function() {
                                t._raiseEvent("0", s);
                                s.isOpen = true;
                                a.jqx.aria(a(s.element), "aria-expanded", true)
                            })
                        }
                    }
                }
            }, this.animationShowDelay)
        }
    })
})(jqxBaseFramework);
