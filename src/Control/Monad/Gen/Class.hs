{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE UndecidableInstances   #-}
{-# LANGUAGE CPP   #-}
module Control.Monad.Gen.Class where
-- Import the non-depricated one
#if MIN_VERSION_mtl(2, 2, 0)
import Control.Monad.Except
#else
import Control.Monad.Trans.Error
#endif

import Control.Monad.Trans.Identity
import Control.Monad.Trans.Maybe
import Control.Monad.List
import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer

-- | The MTL style class for generating fresh values
class Monad m => MonadGen e m | m -> e where
  -- | Generate a fresh value @e@, @gen@ should never produce the
  -- same value within a monadic computation.
  gen :: m e

instance MonadGen e m => MonadGen e (IdentityT m) where
  gen = lift gen
instance MonadGen e m => MonadGen e (StateT s m) where
  gen = lift gen
instance MonadGen e m => MonadGen e (ReaderT s m)  where
  gen = lift gen
instance (MonadGen e m, Monoid s) => MonadGen e (WriterT s m)  where
  gen = lift gen
instance MonadGen e m => MonadGen e (ListT m) where
  gen = lift gen
instance MonadGen e m => MonadGen e (MaybeT m) where
  gen = lift gen

#if MIN_VERSION_mtl(2, 2, 0)
instance (MonadGen e m) => MonadGen e (ExceptT e m) where
  gen = lift gen
#else
instance (MonadGen e m, Error err) => MonadGen e (ErrorT err m) where
  gen = lift gen
#endif
