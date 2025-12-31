#include <windows.h>
#include <string>

// Function to copy text to clipboard
void CopyToClipboard(const std::wstring& text) {
    if (!OpenClipboard(nullptr)) return;
    EmptyClipboard();
    HGLOBAL hGlob = GlobalAlloc(GMEM_MOVEABLE, (text.length() + 1) * sizeof(wchar_t));
    if (hGlob) {
        memcpy(GlobalLock(hGlob), text.c_str(), (text.length() + 1) * sizeof(wchar_t));
        GlobalUnlock(hGlob);
        SetClipboardData(CF_UNICODETEXT, hGlob);
    }
    CloseClipboard();
}

LRESULT CALLBACK ToastWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    static HFONT hFont = nullptr;
    switch (message) {
    case WM_CREATE:
        hFont = CreateFontW(20, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_SWISS, L"Microsoft YaHei");
        SetTimer(hWnd, 1, 1000, nullptr);
        break;
    case WM_TIMER:
        KillTimer(hWnd, 1);
        DestroyWindow(hWnd);
        break;
    case WM_PAINT: {
        PAINTSTRUCT ps;
        HDC hdc = BeginPaint(hWnd, &ps);
        RECT rect;
        GetClientRect(hWnd, &rect);
        SetBkMode(hdc, TRANSPARENT);
        HFONT hOldFont = (HFONT)SelectObject(hdc, hFont);
        DrawTextW(hdc, L"路径已复制到剪贴板", -1, &rect, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
        SelectObject(hdc, hOldFont);
        EndPaint(hWnd, &ps);
        break;
    }
    case WM_DESTROY:
        if (hFont) DeleteObject(hFont);
        PostQuitMessage(0);
        break;
    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return 0;
}

void ShowToast() {
    const wchar_t CLASS_NAME[] = L"ToastClass";
    WNDCLASSW wc = {};
    wc.lpfnWndProc = ToastWndProc;
    wc.hInstance = GetModuleHandle(nullptr);
    wc.lpszClassName = CLASS_NAME;
    wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
    wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
    RegisterClassW(&wc);

    int w = 240, h = 50;
    int x = (GetSystemMetrics(SM_CXSCREEN) - w) / 2;
    int y = (GetSystemMetrics(SM_CYSCREEN) - h) / 2;

    HWND hWnd = CreateWindowExW(WS_EX_TOPMOST | WS_EX_TOOLWINDOW, CLASS_NAME, L"", WS_POPUP | WS_BORDER, x, y, w, h, nullptr, nullptr, GetModuleHandle(nullptr), nullptr);
    ShowWindow(hWnd, SW_SHOW);
    
    MSG msg;
    while (GetMessage(&msg, nullptr, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
}

// Entry point for Windows GUI application (no console window)
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow) {
    int argc;
    LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);
    
    if (argc > 1) {
        std::wstring allPaths;
        for (int i = 1; i < argc; ++i) {
            if (i > 1) allPaths += L"\r\n";
            allPaths += argv[i];
        }
        
        CopyToClipboard(allPaths);
        ShowToast();
    }
    
    LocalFree(argv);
    return 0;
}
