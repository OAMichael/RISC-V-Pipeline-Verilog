#include <memory>

namespace Sim {

template<class VModuleClass>
class VModule {
public:
    VModule() : modulePtr_(std::make_unique<VModuleClass>()), ticks_(0) {}

    ~VModule() {
        modulePtr_->final();
    }

    uint64_t negedge() {
        ++ticks_;
        modulePtr_->clk = 0;
        modulePtr_->eval();
        return ticks_;
    }

    uint64_t posedge() {
        ++ticks_;
        modulePtr_->clk = 1;
        modulePtr_->eval();
        return ticks_;        
    }

    uint64_t clock() {
        posedge();
        return negedge();
    }

    uint64_t ticks() const {
        return ticks_;
    }

    std::unique_ptr<VModuleClass>& operator->() {
        return modulePtr_;
    }

    const std::unique_ptr<VModuleClass>& operator->() const {
        return modulePtr_;
    }

private:
    std::unique_ptr<VModuleClass> modulePtr_;

protected:
    uint64_t ticks_;
};
}
